include("../common/submitter.jl")

PROBLEM_DIR = "problems/maxstab/expset-2"
PREFIXES = ["mssp2-n$n-d$d" for n in 120:20:200, d in [10, 20, 30]]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)

FUNCS = [
    "vf", "vf_C", "vf_B", "vf_CB",
    "vfB_w50", "vfB_w50_C", "vfB_w50_B", "vfB_w50_CB",
    "dpB_l20_w50", "dpB_l20_w50_C", "dpB_l20_w50_B", "dpB_l20_w50_CB",
]

submit("src/maxstab/exp-02-cluster.jl", FUNCS, PROBLEMS)
