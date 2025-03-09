include("../common/submitter.jl")

using Printf

PROBLEM_DIR = "problems/knapsack/expset-3"
PREFIXES = ["kpp3-n$n" for n in 40:1:60]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)

vf_name(w) = @sprintf("vf_w%02d", w)
dp_name(w) = @sprintf("dp_w%02d", w)

FUNCS = [
    [vf_name(w) for w in [0, 5, 10, 20, 30, 40, 50]]...,
    [dp_name(w) for w in [5, 10, 20, 30, 40, 50]]...,
]

submit("src/knapsack/exp-04-cluster.jl", FUNCS, PROBLEMS)
