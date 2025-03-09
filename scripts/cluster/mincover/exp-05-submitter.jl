include("../common/submitter.jl")

using Printf

PROBLEM_DIR = "problems/mincover/expset-4"
PREFIXES = [@sprintf("mcp4-n%03d-r%02d", n, r) for n in 70:10:120, r in [8, 10, 12, 14, 16]]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)

vf_name(w) = @sprintf("vf_w%02d", w)
dp_name(w) = @sprintf("dp_w%03d", w)
sd_name(p) = @sprintf("sd_p%03d", p)

FUNCS = [
    # [sd_name(p) for p in [50, 100, 150, 200, 250, 300, 400, 500]]...,
    [sd_name(p) for p in [200, 600, 800]]...,
]

submit("src/mincover/exp-05-cluster.jl", FUNCS, PROBLEMS; time="24:00:00", uuid="20501c90-6074-11ee-2fca-d51007539fab")
