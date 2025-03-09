include("../common/submitter.jl")

PROBLEM_DIR = "problems/mincover/expset-1"
PREFIXES = ["mcp-n$n-p$p" for n in 120:20:200, p in lpad.([6,8,10,12], 2, '0')]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)

FUNCS = [
    "vf", "vfM_w50", "vfB_w50",
    "dpM_l20_w50", "dpB_l20_w50",
    ["cg$(mc)_l20_c$(c)" for c in [200, 400, 800], mc in [2, 3, 5]]...,
]

submit("src/mincover/exp-01-cluster.jl", FUNCS, PROBLEMS)
