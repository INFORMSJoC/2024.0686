include("../common/submitter.jl")

using Printf

PROBLEM_DIR = "data/problems/knapsack/expset-4"
PREFIXES = [@sprintf("kpp4-n%02d-r%02d", n, r) for n in 40:2:60, r in [50, 55, 60]]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)

vf_name(w) = @sprintf("vf_w%02d", w)
dd_name(w) = @sprintf("dd_w%03d", w)
sd_name(p) = @sprintf("sd_p%04d", p)

FUNCS = [
    [vf_name(w) for w in [0]]...,
    [dd_name(w) for w in [10, 20, 30, 50, 70, 100, 150, 200, 250, 300]]...,
    [sd_name(p) for p in [100, 200, 300, 500, 700, 1000, 1500, 2000, 2500, 3000]]...,
]

submit("src/knapsack/exp-05-cluster.jl", FUNCS, PROBLEMS; time="24:00:00")
