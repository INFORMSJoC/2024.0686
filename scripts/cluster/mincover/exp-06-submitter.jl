include("../common/submitter.jl")

using Printf

PROBLEM_DIR = "data/problems/mincover/expset-4"
PREFIXES = [@sprintf("mcp4-n%03d-r%02d", n, r) for n in 70:10:120, r in [8, 10, 12, 14, 16]]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)

vf_name(w) = @sprintf("vf_w%02d", w)
dd_name(w) = @sprintf("dd_w%03d", w)
sd_name(p) = @sprintf("sd_p%04d", p)

FUNCS = [
    # [vf_name(w) for w in [0]]...,
    # [dd_name(w) for w in [50, 100, 150, 200, 250, 300]]...,
    # [sd_name(p) for p in [100, 200, 300, 500, 700, 1000, 1500, 2000, 2500, 3000]]...,
    [dd_name(w) for w in [10, 20, 30, 70]]...,
]

submit("src/mincover/exp-06-cluster.jl", FUNCS, PROBLEMS; time="24:00:00", uuid="e5349526-7e6b-11ee-10dd-957c650eaa7e")
