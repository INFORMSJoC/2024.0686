using KnapsackPricing, KnapsackPricing.Analysis, JuMP
using JSON, Printf, Random, Graphs

include("../common/print-flush.jl")
include("../common/run.jl")
include("../common/names.jl")
include("../common/cluster.jl")

# Models
function create_vf_model(prob_file, result, pregenerate)
    prob = read_problem(prob_file)
    model = value_function_model(prob; threads=1, heuristic=true)

    if pregenerate > 0
        samples = sample_maximal_solutions(prob.weights, prob.capacity, pregenerate)
        KnapsackPricing.add_value_function_constraint.(Ref(model), convert_set_to_x.(samples, num_items(prob)))
    end
    
    return model
end

function create_dp_model(prob_file, result, grouping, width)
    prob = read_problem(prob_file)
    model = augment_model_default(prob, DDSingleEnded(;grouping), width; threads=1, heuristic=true)
    model[:cg_layers] = model[:layers]
    model[:cg_partition] = model[:item_partition]
    model[:extract_graph] = cggraph
    return model
end

# Test functions
begin
    # Value function
    for w in [0, 5, 10, 20, 30, 40, 50]
        funcname = Symbol(@sprintf("vf_w%02d", w))
        @eval $funcname(file, result) = create_vf_model(file, result, $w)
    end

    # DP nodes sweep
    for w in [5, 10, 20, 30, 40, 50]
        funcname = Symbol(@sprintf("dp_w%02d", w))
        @eval $funcname(file, result) = create_dp_model(file, result, 2, $w)
    end
end

# Summary
function summarize!(result, model)
    result[:solution_time] = solve_time(model)
    result[:total_time] = result[:preprocess_time] + result[:solution_time]

    has_solution = result_count(model) > 0
    result[:best_obj] = has_solution ? objective_value(model) : 0.0
    result[:best_bound] = objective_bound(model)
    result[:gap] = has_solution ? relative_gap(model) : 1.0
    result[:bb_nodes] = node_count(model)

    result[:num_variables] = num_variables(model)
    result[:num_constraints] = num_constraints(model; count_variable_in_set_constraints = false)
    result[:num_separations] = haskey(model, :vf_x) ? length(model[:vf_x]) : 0

    # result[:solution_x] = KnapsackPricing.convert_x_to_set(value.(model[:x]))
    # result[:solution_t] = KnapsackPricing.expand_t(value.(model[:t]), model[:prob])

    if haskey(model, :extract_graph)
        dpgraph = model[:extract_graph](model)
        result[:dp_num_nodes] = nv(dpgraph)
        result[:dp_num_arcs] = length(model[:dd_arcs])
        result[:dp_num_paths] = count_paths(collect(model[:dd_arcs]))
    end
end

# Execute
run_cluster(ARGS...)
