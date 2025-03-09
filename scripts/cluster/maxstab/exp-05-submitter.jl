include("../common/submitter.jl")

using Printf

PROBLEM_DIR = "problems/maxstab/expset-5"
PREFIXES = ["mssp5-n$n-d$d" for n in 100:20:160, d in [10, 15, 20, 30]]
PREFIXES_LONG = ["mssp5-n$n-d$d" for n in 180, d in [10, 15, 20, 30]]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)
PROBLEMS_LONG = joinpath.([PROBLEM_DIR], PREFIXES_LONG)

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

submit("src/maxstab/exp-05-cluster.jl", FUNCS, PROBLEMS)
submit("src/maxstab/exp-05-cluster.jl", FUNCS, PROBLEMS_LONG, time="12:00:00")
