include("../common/submitter.jl")

using Printf

PROBLEM_DIR = "data/problems/mincover/expset-2"
PREFIXES = [@sprintf("mcp2-n%03d-r%02d", n, r) for n in 80:10:120, r in [10, 12, 15]]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)

vf_name(w) = @sprintf("vf_w%02d", w)
dpA_name(w) = @sprintf("dpA_w%03d", w)
dpB_name(w) = @sprintf("dpB_w%03d", w)
nsA_name(n) = @sprintf("nsA_n%03d_w%03d", n, n * 2)
nsB_name(n) = @sprintf("nsB_n%03d_w%03d", n, n * 2)

FUNCS = [
    [vf_name(w) for w in [0, 5, 10, 20, 30, 40, 50]]...,
    [dpA_name(w) for w in [5, 10, 20, 30, 40, 50]]...,
]

submit("src/mincover/exp-02-cluster.jl", FUNCS, PROBLEMS)
