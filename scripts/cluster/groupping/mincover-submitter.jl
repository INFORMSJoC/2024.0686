include("../common/submitter.jl")

using Printf

PROBLEM_DIR = "problems/mincover/expset-4"
PREFIXES = [@sprintf("mcp4-n%03d-r%02d", n, r) for n in 70:10:120, r in [8, 10, 12, 14, 16]]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)

dd_name(w, l) = @sprintf("dd_w%03d_l%03d", w, l)

FUNCS = [
    [dd_name(w, l) for w in [50, 300], l in [20, 200]]...,
]

submit("src/groupping/mincover-cluster.jl", FUNCS, PROBLEMS; time="24:00:00")
