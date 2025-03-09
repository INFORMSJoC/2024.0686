include("../common/submitter.jl")

using Printf

PROBLEM_DIR = "problems/knapsack/expset-3"
PREFIXES = ["kpp3-n$n" for n in 40:1:60]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)

vf_name(w) = @sprintf("vf_w%02d", w)
dpA_name(w) = @sprintf("dpA_w%03d", w)
dpB_name(w) = @sprintf("dpB_w%03d", w)
nsA_name(n) = @sprintf("nsA_n%03d_w%03d", n, n * 2)
nsB_name(n) = @sprintf("nsB_n%03d_w%03d", n, n * 2)

FUNCS = [
    [vf_name(w) for w in [0, 25, 50]]...,
    [dpA_name(w) for w in [5, 10, 20, 30, 40, 50]]...,
    [dpB_name(w) for w in [5, 10, 20, 30, 40, 50]]...,
    [nsA_name(n) for n in [10, 20, 40, 60, 80, 100]]...,
    [nsB_name(n) for n in [10, 20, 40, 60, 80, 100]]...,
]

submit("src/knapsack/exp-03-cluster.jl", FUNCS, PROBLEMS)
