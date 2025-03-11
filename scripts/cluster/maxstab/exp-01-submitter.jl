include("../common/submitter.jl")

PROBLEM_DIR = "data/problems/maxstab/expset-1"
PREFIXES = ["mssp-n$n-d$d" for n in 120:20:200, d in [10, 20, 30]]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)

FUNCS = [
    "vf", "vf_R",
    "dpM_l20_w50", "dpM_l20_w50_R",
    "dpB_l20_w50", "dpB_l20_w50_R",
    ["cg$(mc)_l20_c$(c)" for c in [200, 400, 800], mc in [2, 3, 5]]...,
]

submit("src/maxstab/exp-01-cluster.jl", FUNCS, PROBLEMS)
