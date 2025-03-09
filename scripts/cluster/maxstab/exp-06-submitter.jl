include("../common/submitter.jl")

using Printf

PROBLEM_DIR = "problems/maxstab/expset-6"
PREFIXES = [@sprintf("mssp6-n%03d-d%02d", n, d) for n in 120:10:160, d in 10:2:20]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)

vf_name(w) = @sprintf("vf_w%02d", w)
dd_name(w) = @sprintf("dd_w%03d", w)
sd_name(p) = @sprintf("sd_p%04d", p)

FUNCS = [
    # [vf_name(w) for w in [0]]...,
    # [dd_name(w) for w in [10, 20, 30, 50, 70, 100]]...,
    # [sd_name(p) for p in [100, 200, 300, 500, 700, 1000]]...,
    [dd_name(w) for w in [150, 200, 250, 300]]...,
    [sd_name(p) for p in [100, 200, 300, 500, 700, 1000, 1500, 2000, 2500, 3000]]...,
]

submit("src/maxstab/exp-06-cluster.jl", FUNCS, PROBLEMS; time="24:00:00", uuid="3144a2b6-63bf-11ee-2643-d10e33db1c12")
