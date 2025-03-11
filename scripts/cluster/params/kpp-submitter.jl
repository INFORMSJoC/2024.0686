include("../common/submitter.jl")

using Printf

PARAMS = [
    (55, 25, 20),
    # Varied ratio
    (35, 25, 20),
    (45, 25, 20),
    (65, 25, 20),
    (75, 25, 20),
    # Varied density spread
    (55,  5, 20),
    (55, 15, 20),
    (55, 35, 20),
    (55, 50, 20),
    # Varied multiplier
    (55, 25, 10),
    (55, 25, 15),
    (55, 25, 25),
    (55, 25, 30)
]

PROBLEM_DIR = "data/problems/knapsack/params"
PREFIXES = [@sprintf("kpp5-n%02d-r%02d-d%02d-m%02d", n, r, d, m) for n in [40, 50, 60], (r, d, m) in PARAMS]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)

submit("src/params/kpp-cluster.jl", ["vf"], PROBLEMS; time="12:00:00")
