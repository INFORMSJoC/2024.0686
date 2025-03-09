include("../common/submitter.jl")

using Printf

PROBLEMS = readlines("src/interdiction/ki-probs.txt")
# PROBLEMS = readlines("src/interdiction/test.txt")

vf_name(w) = @sprintf("vf_w%02d", w)
dd_name(w) = @sprintf("dd_w%03d", w)
sd_name(p) = @sprintf("sd_p%04d", p)

FUNCS = [
    [vf_name(w) for w in [0]]...,
    # [dd_name(w) for w in [10, 20, 30, 50, 70, 100, 150]]...,
    # [sd_name(p) for p in [100, 200, 300, 500, 700, 1000, 1500]]...,
    # [dd_name(w) for w in [200, 250, 300]]...,
    [sd_name(p) for p in [1000]]...,
]

submit2("src/interdiction/exp-01-cluster.jl", FUNCS, PROBLEMS; time="12:00:00", mem="16G")
