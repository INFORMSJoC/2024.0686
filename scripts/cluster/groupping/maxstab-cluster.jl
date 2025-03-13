include("../common/common.jl")

# Models
function create_dp_model(prob_file, result, numlayers, width, sampler_fn, num_nodes, include_arcs)
    prob = read(prob_file, MaxStableSetPricing)
    rng = make_rng(result[:rng_seed], 2)
    sampler = sampler_fn(prob)

    grouping = ceil(Int, num_items(prob) / numlayers)
    partition = Partition(prob, RandomPartitioning(grouping, rng[1]))
    dpgraph = DPGraph(prob, partition)
    populate_nodes!(dpgraph, BitSet.(rand(rng[2], sampler, width)); num_nodes, include_arcs)

    model = dpgraph_model(dpgraph; threads=1)
    return model
end

make_max_sampler(prob) = MaximalStableSetSampler(prob)
make_bf_sampler(prob) = BilevelFeasibleSampler(make_max_sampler(prob))

function define_dp_model(w, l)
    funcname = Symbol(@sprintf("dd_w%03d_l%03d", w, l))
    @eval $funcname(file, result) = create_dp_model(file, result, $l, $w, make_max_sampler, nothing, true)
end

# Test functions
begin
    # DP nodes sweep
    for w in [10, 20, 30, 50, 70, 100, 150, 200, 250, 300], l in [20, 40, 80, 200]
        define_dp_model(w, l)
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
run_cluster(ARGS..., batch=10)
