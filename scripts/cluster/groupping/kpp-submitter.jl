include("../common/submitter.jl")

using Printf

PROBLEM_DIR = "problems/knapsack/expset-4"
PREFIXES = [@sprintf("kpp4-n%02d-r%02d", n, r) for n in 40:2:60, r in [50, 55, 60]]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)

dd_name(w, g) = @sprintf("dd_w%03d_g%1d", w, g)

FUNCS = [
    [dd_name(w, g) for w in [30], g in [1, 2]]...,
]

submit("src/groupping/kpp-cluster.jl", FUNCS, PROBLEMS; time="24:00:00")
