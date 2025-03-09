include("../common/common.jl")

# Models
function create_vf_model(prob_file, result, pregenerate, sampler_fn, trivial_cuts, trivial_bound)
    prob = read(prob_file, MaxStableSetPricing)
    model = value_function_model(prob; threads=1, trivial_cuts, trivial_bound)

    if pregenerate > 0
        rng = make_rng(result[:rng_seed], 2)
        sampler = sampler_fn(prob)
        samples = BitSet.(rand(rng[2], sampler, pregenerate))
        add_value_function_constraint!.(Ref(model), samples)
    end

    return model
end

function create_dp_model(prob_file, result, width, numlayers, sampler_fn, trivial_cuts, trivial_bound)
    prob = read(prob_file, MaxStableSetPricing)
    rng = make_rng(result[:rng_seed], 2)
    sampler = sampler_fn(prob)

    grouping = ceil(Int, num_items(prob) / numlayers)
    partition = Partition(prob, RandomPartitioning(grouping, rng[1]))
    dpgraph = DPGraph(prob, partition)
    populate_nodes!(dpgraph, BitSet.(rand(rng[2], sampler, width)))

    model = dpgraph_model(dpgraph; threads=1, trivial_cuts, trivial_bound)
    return model
end

function create_cg_model(prob_file, result, num_cols, numlayers, min_connections, trivial_cuts, trivial_bound)
    prob = read(prob_file, MaxStableSetPricing)
    rng = make_rng(result[:rng_seed], 1)

    grouping = ceil(Int, num_items(prob) / numlayers)
    partition = Partition(prob, RandomPartitioning(grouping, rng[1]))
    dpgraph = DPGraph(prob, partition)

    model = colgen_model(dpgraph, num_cols; threads=1, filter=(i, o) -> i + o >= min_connections, trivial_cuts, trivial_bound)
    return model
end

make_max_sampler(prob) = MaximalStableSetSampler(prob)
make_bf_sampler(prob) = BilevelFeasibleSampler(make_max_sampler(prob))

# Test functions
for (suffix, trivial_props) in zip(["", "_C", "_B", "_CB"], [(false, false), (true, false), (false, true), (true, true)])
    for (s, sampler_fn) in zip(["M", "B"], [make_max_sampler, make_bf_sampler])
        # Value function
        funcname = Symbol("vf$(suffix)")
        @eval $funcname(file, result) = create_vf_model(file, result, 0, $sampler_fn, $trivial_props...)

        funcname = Symbol("vf$(s)_w50$(suffix)")
        @eval $funcname(file, result) = create_vf_model(file, result, 50, $sampler_fn, $trivial_props...)

        # DP graph model
        funcname = Symbol("dp$(s)_l20_w50$(suffix)")
        @eval $funcname(file, result) = create_dp_model(file, result, 50, 20, $sampler_fn, $trivial_props...)
    end

    # Column generation
    for num_cols in [200, 400, 800], mc in [2, 3, 5]
        funcname = Symbol("cg$(mc)_l20_c$(num_cols)$(suffix)")
        @eval $funcname(file, result) = create_cg_model(file, result, $num_cols, 20, $mc, $trivial_props...)
    end
end

# Summary
function summarize!(result, model)
    for symbol in [:callback_time, :callback_calls, :subproblem_time, :subproblem_times]
        result[symbol] = model[symbol]
    end

    result[:solution_time] = solve_time(model)
    result[:total_time] = result[:preprocess_time] + result[:solution_time]

    has_solution = result_count(model) > 0
    result[:best_obj] = has_solution ? objective_value(model) : 0.0
    result[:best_bound] = objective_bound(model)
    result[:gap] = has_solution ? relative_gap(model) : 1.0
    result[:bb_nodes] = node_count(model)

    result[:num_variables] = num_variables(model)
    result[:num_constraints] = num_constraints(model; count_variable_in_set_constraints = false)
    result[:num_separations] = length(model[:vf_x])

    result[:solution_x] = CombinatorialPricing.convert_x_to_set(value.(model[:x]))
    result[:solution_t] = CombinatorialPricing.expand_t(value.(model[:t]), model[:prob])

    # result[:separations] = CombinatorialPricing.convert_x_to_set.(model[:vf_x])
    
    if haskey(model, :dpgraph)
        dpgraph = model[:dpgraph]
        ugraph = unique_graph(dpgraph)
        result[:dp_num_nodes] = nv(dpgraph)
        result[:dp_num_arcs] = ne(dpgraph)
        result[:dp_num_paths] = count_paths(dpgraph)
        result[:dp_unique_arcs] = ne(ugraph)
        result[:dp_unique_paths] = count_unique_paths(dpgraph)
        result[:dp_partition] = dpgraph.partition
    end
end

# Execute
run_cluster(ARGS...)
