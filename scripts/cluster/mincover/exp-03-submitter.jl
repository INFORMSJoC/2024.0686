include("../common/submitter.jl")

using Printf

PROBLEM_DIR = "data/problems/mincover/expset-3"
PREFIXES = [@sprintf("mcp3-n%03d-r%02d", n, r) for n in 80:10:130, r in [6, 8, 10, 12, 14]]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)

vf_name(w) = @sprintf("vf_w%02d", w)
dp_name(w) = @sprintf("dp_w%02d", w)

FUNCS = [
    [vf_name(w) for w in [0, 10, 20, 30, 50, 80]]...,
    [dp_name(w) for w in [10, 20, 30, 50, 80]]...,
]

submit("src/mincover/exp-03-cluster.jl", FUNCS, PROBLEMS; time="24:00:00")
