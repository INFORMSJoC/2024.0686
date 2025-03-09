include("../common/submitter.jl")

using Printf

PROBLEM_DIR = "problems/maxstab/expset-7"
PREFIXES = [@sprintf("mssp7-n%03d-d%02d", n, d) for n in 120:10:180, d in 12:4:24]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)

dd_name(w, l) = @sprintf("dd_w%03d_l%03d", w, l)

FUNCS = [
    [dd_name(w, l) for w in [10, 50, 150], l in [20, 200]]...,
]

submit("src/groupping/maxstab-cluster.jl", FUNCS, PROBLEMS; time="24:00:00")
