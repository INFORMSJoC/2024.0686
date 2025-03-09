include("../common/submitter.jl")

using Printf

PROBLEM_DIR = "problems/knapsack/expset-1"
PREFIXES = ["kpp-n$n" for n in 40:2:60]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)

hybrid_name(w, c) = @sprintf("cg_w%02d_c%03d", w, c)

FUNCS = [
    "vf_w00", "vf_w25", "vf_w50",
    [hybrid_name(w, 0) for w in [5, 10, 15, 20, 25, 30, 40, 50, 60, 80]]...,
    [hybrid_name(25, c) for c in [25, 50, 75, 100, 150, 200, 300, 400, 600, 800]]...,
]

submit("src/knapsack/exp-01-cluster.jl", FUNCS, PROBLEMS, time="6:00:00")
