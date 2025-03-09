include("../common/submitter.jl")

using Printf

PROBLEMS = readlines("src/interdiction/ki-probs.txt")
# PROBLEMS = readlines("src/interdiction/test.txt")

dd_name(w, l) = @sprintf("dd_w%03d_l%03d", w, l)

FUNCS = [
    [dd_name(w, l) for w in [10], l in [20, 200]]...,
]

submit2("src/groupping/interdiction-cluster.jl", FUNCS, PROBLEMS; time="12:00:00", mem="16G")
