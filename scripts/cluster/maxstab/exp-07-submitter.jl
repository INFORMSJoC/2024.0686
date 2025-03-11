include("../common/submitter.jl")

using Printf

PROBLEM_DIR = "data/problems/maxstab/expset-7"
PREFIXES = [@sprintf("mssp7-n%03d-d%02d", n, d) for n in 120:10:180, d in 12:4:24]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)

vf_name(w) = @sprintf("vf_w%02d", w)
dd_name(w) = @sprintf("dd_w%03d", w)
sd_name(p) = @sprintf("sd_p%04d", p)

FUNCS = [
    [vf_name(w) for w in [0]]...,
    [dd_name(w) for w in [10, 20, 30, 50, 70, 100, 150, 200, 250, 300]]...,
    [sd_name(p) for p in [100, 200, 300, 500, 700, 1000, 1500, 2000, 2500, 3000]]...,
]

submit("src/maxstab/exp-07-cluster.jl", FUNCS, PROBLEMS; time="24:00:00")
