using DataFrames, CSV

function inspect_efficiency(uuid)
    file = "jobs/$uuid/job_ids.txt"
    df = CSV.read(file, DataFrame; delim=";", header=["func", "prob", "id"])
    df[!, :cpu_eff] .= 0.
    df[!, :mem_eff] .= 0.
    df[!, :mem] .= ""
    for i in 1:size(df, 1)
        eff_out = read(`seff $(df[i,:id])`, String)
        df[i, :cpu_eff] = parse(Float64, match(r"^CPU Efficiency: ([0-9\.]+)%"m, eff_out).captures[1])
        df[i, :mem_eff] = parse(Float64, match(r"^Memory Efficiency: ([0-9\.]+)%"m, eff_out).captures[1])
        df[i, :mem] = match(r"^Memory Utilized: (.+)$"m, eff_out).captures[1]
    end
    return df
end
