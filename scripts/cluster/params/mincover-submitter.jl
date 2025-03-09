include("../common/submitter.jl")

using Printf

PARAMS = [
    (12, 35, 10, 23, 28, 23),
    # Varied ratio
    ( 4, 35, 10, 23, 28, 23),
    ( 8, 35, 10, 23, 28, 23),
    (16, 35, 10, 23, 28, 23),
    (20, 35, 10, 23, 28, 23),
    # Varied element costs
    (12,  5, 10, 23, 28, 23),
    (12, 20, 10, 23, 28, 23),
    (12, 50, 10, 23, 28, 23),
    (12, 65, 10, 23, 28, 23),
    # Varied set cost multiplier
    (12, 35,  1, 23, 28, 23),
    (12, 35,  5, 23, 28, 23),
    (12, 35, 15, 23, 28, 23),
    (12, 35, 20, 23, 28, 23),
    # Varied include prob
    (12, 35, 10,  3, 28, 23),
    (12, 35, 10, 13, 28, 23),
    (12, 35, 10, 33, 28, 23),
    (12, 35, 10, 43, 28, 23),
    # Varied tolled prob
    (12, 35, 10, 23,  8, 23),
    (12, 35, 10, 23, 18, 23),
    (12, 35, 10, 23, 38, 23),
    (12, 35, 10, 23, 48, 23),
    # Varied multiplier
    (12, 35, 10, 23, 28, 10),
    (12, 35, 10, 23, 28, 15),
    (12, 35, 10, 23, 28, 30)
]

PROBLEM_DIR = "problems/mincover/params"
PREFIXES = [@sprintf("mcp5-n%03d-r%02d-e%02d-s%02d-j%02d-p%02d-m%02d", n, r, e, s, j, p, m) for n in [70, 90, 110], (r, e, s, j, p, m) in PARAMS]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)

submit("src/params/mincover-cluster.jl", ["vf"], PROBLEMS; time="24:00:00")
