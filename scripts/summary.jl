using JSON, CSV, DataFrames

function summarize(uuid, desc; excluded=[])
    files = map(e -> joinpath.([e[1]], e[3]), walkdir(joinpath("results", uuid)))
    result_files = collect(Iterators.flatten(files))
    filter!(f -> splitext(f)[2] == ".json", result_files)
    filter!(f -> basename(f) ∉ excluded, result_files)

    df = DataFrame([k => [] for k in first.(desc)])
    for file in result_files
        jdict = JSON.parse(read(file, String))
        push!(df, Dict(k => v(jdict) for (k, v) in desc))
    end

    CSV.write("summaries/$uuid.csv", df)
    return df
end

function make_desc()
    desc = Pair[]
    for s in [
        :func, :prob,
        :total_time, :best_obj, :best_bound, :gap,
        :preprocess_time, :solution_time, :callback_time, :subproblem_time,
        :callback_calls, :num_separations, :bb_nodes,
        :num_variables, :num_constraints,
        :dp_num_nodes, :dp_num_arcs, :dp_num_paths, :dp_unique_arcs, :dp_unique_paths,
        ]
        push!(desc, s => j -> get(j, string(s), missing))
    end
    return desc
end
