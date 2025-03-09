include("../common/common.jl")

# Models
function vf(prob_file, result)
    prob = read(prob_file, MinSetCoverPricing)
    model = value_function_model(prob; threads=1)
    return model
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
