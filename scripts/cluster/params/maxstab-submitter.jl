include("../common/submitter.jl")

using Printf

PARAMS = [
    (16, 100, 40, 13),
    # Varied density
    ( 8, 100, 40, 13),
    (12, 100, 40, 13),
    (20, 100, 40, 13),
    (24, 100, 40, 13),
    # Varied value spread
    (16,  20, 40, 13),
    (16,  60, 40, 13),
    (16, 140, 40, 13),
    (16, 180, 40, 13),
    # Varied proportion
    (16, 100, 10, 13),
    (16, 100, 25, 13),
    (16, 100, 55, 13),
    (16, 100, 70, 13),
    # Varied multiplier
    (16, 100, 40, 10),
    (16, 100, 40, 16),
    (16, 100, 40, 20)
]

PROBLEM_DIR = "problems/maxstab/params"
PREFIXES = [@sprintf("mssp8-n%03d-d%02d-v%03d-p%02d-m%02d", n, d, v, p, m) for n in [120, 140, 160], (d, v, p, m) in PARAMS]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)

submit("src/params/maxstab-cluster.jl", ["vf"], PROBLEMS; time="12:00:00")
