[![INFORMS Journal on Computing Logo](https://INFORMSJoC.github.io/logos/INFORMS_Journal_on_Computing_Header.jpg)](https://pubsonline.informs.org/journal/ijoc)

# Solving Combinatorial Pricing Problems using Embedded Dynamic Programming Models <!-- omit from toc -->

This archive is distributed in association with the [INFORMS Journal on
Computing](https://pubsonline.informs.org/journal/ijoc) under the [MIT License](LICENSE).

The software and data in this repository are a snapshot of the software and data
that were used in the research reported on in the paper _Solving Combinatorial Pricing Problems using Embedded Dynamic Programming Models_ \[[1](#readme-ref1)\] by Q. M. Bui, M. Carvalho and J. Neto. 
The snapshot is based on 
[this repository](https://github.com/minhcly95/CombinatorialPricing.jl). 

## Table of Contents <!-- omit from toc -->

- [Cite](#cite)
- [Installation](#installation)
- [Basic Usage](#basic-usage)
- [Other Models](#other-models)
  - [Value Function Model](#value-function-model)
  - [Selection Diagram Model](#selection-diagram-model)
  - [Decision Diagram Model](#decision-diagram-model)
- [Supported Problems](#supported-problems)
  - [Problem Instance Sets](#problem-instance-sets)
  - [Generate New Instances](#generate-new-instances)
- [Results](#results)
- [Replicating](#replicating)
- [References](#references)

## Cite

To cite the contents of this repository, please cite both the paper and this repo, using their respective DOIs.

https://doi.org/?????

https://doi.org/?????.cd

Below is the BibTex for citing this snapshot of the repository.

```
@misc{CacheTest,
  author =        {Q. M. Bui, M. Carvalho, J. Neto},
  publisher =     {INFORMS Journal on Computing},
  title =         {{Solving combinatorial pricing problems using embedded dynamic programming models}},
  year =          {2025},
  doi =           {???},
  url =           {https://github.com/INFORMSJoC/2024.0686},
  note =          {Available for download at https://github.com/INFORMSJoC/2024.0686},
}  
```

## Installation

The package is not available on the registry. Please clone the repository and
add it as a [local package](https://pkgdocs.julialang.org/v1/managing-packages/#Adding-a-local-package). You also need to add [JuMP](https://jump.dev/JuMP.jl/stable/) and [Gurobi](https://github.com/jump-dev/Gurobi.jl).

```julia
]add https://github.com/minhcly95/CombinatorialPricing.jl.git
```

## Basic Usage

```julia
using CombinatorialPricing, JuMP, Gurobi

# Import a problem from a file
file = "./problems/knapsack/expset-4/kpp4-n40-r50-01.json"
prob = read(file, KnapsackPricing)

# Create a value function model
model_vf = value_function_model(prob)

# Solve the model
optimize!(model_vf)

# Extract the result
objval = objective_value(model_vf)  # The leader's objective value t'x
followerobj = value(model_vf[:f])   # The follower's objective value (c + t)'x

tvals = value.(model_vf[:t])        # The prices t
xvals = value.(model_vf[:x])        # The follower's decision x
```

## Other Models
The paper \[[1](#readme-ref1)\] introduces 3 models to solve CPPs:
- Value function model (VF);
- Selection diagram model (SD);
- Decision diagram model (DD).

### Value Function Model
```julia
# Create a value function model
model_vf = value_function_model(prob)

# OPTIONAL: add additional value function constraints
sampler = MaximalKnapsackSampler(prob)
sample = rand(sampler)
add_value_function_constraint!(model_vf, sample)
```

### Selection Diagram Model
To create an SD model, we need to provide a selection diagram.
A selection diagram can be created from a list of pairs of items.
To obtain such list, we sample some solutions and extract a random pair from each solution.
```julia
numpairs = 1000

# Sample some solutions
sampler = MaximalKnapsackSampler(prob)
samples = rand(sampler, numpairs)

# Extract random pairs from the samples
pairs = random_pair.(samples)

# Create a selection diagram
sd = sdgraph_from_pairs(prob, pairs)

# Create a model from the SD
model_sd = sdgraph_model(sd)
```

### Decision Diagram Model
To create a DD model, we need to provide a decision diagram.
The decision diagram needs to be populated with some nodes first,
which requires some solution samples.
```julia
ddwidth = 50    # The width of the decision diagram
grouping = 2    # Number of item per layer

# Sample some solutions
sampler = MaximalKnapsackSampler(prob)
samples = rand(sampler, ddwidth)

# Create a parition of items into layers
partition = Partition(prob, RandomPartitioning(grouping))

# Create an empty decision diagram
dd = DPGraph(prob, partition)

# Populate the DD with nodes using the above samples
populate_nodes!(dd, BitSet.(samples))

# Create a model from the DD
model_dd = dpgraph_model(dd)
```

## Supported Problems
The paper \[[1](#readme-ref1)\] implements 4 different CPP specializations:
- Knapsack pricing problem (KPP);
- Maximum stable set pricing problem (MaxSSPP);
- Minimum set cover pricing problem (MinSCPP);
- Knapsack interdiction problem (KIP).

> **Note**: Each problem has its own `sampler` type.

```julia
# Knapsack pricing problem
prob = read("./problems/knapsack/expset-4/kpp4-n40-r50-01.json", KnapsackPricing)
sampler = MaximalKnapsackSampler(prob)

# Maximum stable set pricing problem
prob = read("./problems/maxstab/expset-7/mssp7-n120-d12-01.json", MaxStableSetPricing)
sampler = MaximalStableSetSampler(prob)

# Minimum set cover pricing problem
prob = read("./problems/mincover/expset-4/mcp4-n120-r16-01.json", MinSetCoverPricing)
sampler = MinimalSetCoverSampler(prob)

# Knapsack interdiction problem
prob = read("./problems/interdiction-flatten/CCLW_CCLW_n35_m0.ki", KnapsackInterdiction)
sampler = MaximalKnapsackInterdictionSampler(prob)
```

### Problem Instance Sets
The problem instances tested in \[[1](#readme-ref1)\] are located at:
- KPP: [problems/knapsack/expset-4](problems/knapsack/expset-4)
- MaxSSPP: [problems/maxstab/expset-7](problems/maxstab/expset-7)
- MinSCPP: [problems/mincover/expset-4](problems/mincover/expset-4)
- KIP: [problems/interdiction-flatten](problems/interdiction-flatten)

The instance files for the KPP, MaxSSPP, and MinSCPP are in JSON format and are self-explanatory.
The KIP instances are copied from https://github.com/nwoeanhinnogaehr/bkpsolver.

### Generate New Instances
One can also generate new instances for the KPP, MaxSSPP, and MinSCPP.

> [Distributions.jl](https://github.com/JuliaStats/Distributions.jl) is required to adjust the distributions (`DiscreteUniform`, `Uniform`).

```julia
# KPP
numitems = 40       # Number of knapsack items
prob = generate(KnapsackPricing, numitems;
    weights_dist = DiscreteUniform(1, 100), # Distribution of the weights
    density_dist = Uniform(0.75, 1.25),     # Distribution of the density (value = weight * density)
    capacity_ratio = 0.6,                   # Capacity / Sum of all weights
    tolled_proportion = 0.6,                # Num tolled items / Num items
    tolled_values_multiplier = 2.0          # Extra base value for tolled items
)

# OPTIONAL: write the problem to file
write("kpp.json", prob)
```

```julia
# MaxSSPP
numnodes = 120      # Number of nodes in the graph
prob = generate(MaxStableSetPricing, numitems;
    values_dist = DiscreteUniform(50, 150), # Distribution of the values
    graph_density = 0.16,                   # Density for Erdős–Rényi graph
    tolled_proportion = 0.4,                # Num tolled nodes / Num nodes
    tolled_values_multiplier = 1.3,         # Extra base value for tolled nodes
    random_tolled_proportion = 0.07         # Proportion of tolled nodes chosen at random
)
```

```julia
# MinSCPP
numsets = 80        # Number of sets to generate
prob = generate(MaxStableSetPricing, numsets;
    element_costs_dist = DiscreteUniform(50, 85),   # Distribution of costs of the elements
    set_cost_multiplier_dist = Uniform(0.9, 1.1),   # Random perturbation to the cost of each set
    sets_elements_ratio = 1.23,                     # Num sets / Num elements
    include_probability = 0.23,                     # Probability that an element appears in a set
    tolled_proportion = 0.28,                       # Num tolled sets / Num sets
    tolled_costs_multiplier = 2.3                   # Discounted base costs for tolled sets
)
```

## Results

Figure 1 in the paper shows the results of the multiplication test with different
values of K using `gcc` 7.5 on an Ubuntu Linux box.

![Figure 1](results/mult-test.png)

Figure 2 in the paper shows the results of the sum test with different
values of K using `gcc` 7.5 on an Ubuntu Linux box.

![Figure 1](results/sum-test.png)

## Replicating

To replicate the results in [Figure 1](results/mult-test), do either

```
make mult-test
```
or
```
python test.py mult
```
To replicate the results in [Figure 2](results/sum-test), do either

```
make sum-test
```
or
```
python test.py sum
```

## References
<a id="readme-ref1"></a> \[1\] Quang Minh Bui, Margarida Carvalho, José Neto. Solving Combinatorial Pricing Problems using Embedded Dynamic Programming Models. INFORMS Journal on Computing, accepted paper, 2025. ([arXiv version](https://arxiv.org/abs/2403.12923))
