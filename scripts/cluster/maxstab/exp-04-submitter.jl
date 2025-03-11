include("../common/submitter.jl")

using Printf

PROBLEM_DIR = "data/problems/maxstab/expset-4"
PREFIXES = ["mssp4-n$n-d$d" for n in 100:20:160, d in [10, 15, 20, 30]]
PREFIXES_LONG = ["mssp4-n$n-d$d" for n in 180, d in [10, 15, 20, 30]]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)
PROBLEMS_LONG = joinpath.([PROBLEM_DIR], PREFIXES_LONG)

hybrid_name(w, c) = @sprintf("cg_w%02d_c%03d", w, c)

FUNCS = [
    "vf_w00", "vf_w25", "vf_w50",
    [hybrid_name(w, 0) for w in [5, 10, 15, 20, 25, 30, 40, 50, 60, 80]]...,
    [hybrid_name(25, c) for c in [25, 50, 75, 100, 150, 200, 300, 400, 600, 800]]...,
]

submit("src/maxstab/exp-04-cluster.jl", FUNCS, PROBLEMS, time="6:00:00")
submit("src/maxstab/exp-04-cluster.jl", FUNCS, PROBLEMS_LONG, time="12:00:00")
