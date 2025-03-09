include("../common/common.jl")

# Models
function create_vf_model(prob_file, result, pregenerate, sampler_fn)
    prob = read(prob_file, MaxStableSetPricing)
    model = value_function_model(prob; threads=1)

    if pregenerate > 0
        rng = make_rng(result[:rng_seed], 2)
        sampler = sampler_fn(prob)
        samples = BitSet.(rand(rng[2], sampler, pregenerate))
        add_value_function_constraint!.(Ref(model), samples)
    end

    return model
end

function create_hybrid_model(prob_file, result, width, numlayers, num_cols, sampler_fn, min_connections)
    prob = read(prob_file, MaxStableSetPricing)
    rng = make_rng(result[:rng_seed], 2)
    sampler = sampler_fn(prob)

    grouping = ceil(Int, num_items(prob) / numlayers)
    partition = Partition(prob, RandomPartitioning(grouping, rng[1]))
    dpgraph = DPGraph(prob, partition)
    populate_nodes!(dpgraph, BitSet.(rand(rng[2], sampler, width)))

    model = colgen_model(dpgraph, num_cols; threads=1, filter=(i, o) -> i + o >= min_connections)
    return model
end

make_max_sampler(prob) = MaximalStableSetSampler(prob)
make_bf_sampler(prob) = BilevelFeasibleSampler(make_max_sampler(prob))

function define_hybrid_model(w, c)
    funcname = Symbol(@sprintf("cg_w%02d_c%03d", w, c))
    @eval $funcname(file, result) = create_hybrid_model(file, result, $w, 20, $c, make_max_sampler, 2)
end

# Test functions
begin
    # Value function
    for w in [0, 25, 50]
        funcname = Symbol(@sprintf("vf_w%02d", w))
        @eval $funcname(file, result) = create_vf_model(file, result, $w, make_max_sampler)
    end

    # DP nodes sweep
    for w in [5, 10, 15, 20, 25, 30, 40, 50, 60, 80]
        define_hybrid_model(w, 0)
    end

    # CG nodes sweep
    for c in [25, 50, 75, 100, 150, 200, 300, 400, 600, 800]
        define_hybrid_model(25, c)
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
