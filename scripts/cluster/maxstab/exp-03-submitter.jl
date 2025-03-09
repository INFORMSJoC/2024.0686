include("../common/submitter.jl")

PROBLEM_DIR = "problems/maxstab/expset-3"
PREFIXES = ["mssp3-n$n-d$d" for n in 100:20:160, d in [10, 15, 20, 30]]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)

FUNCS = [
    "vf_w00", "vf_w25", "vf_w50",
    "cg2_l20_w00_c200", "cg2_l20_w00_c400", "cg2_l20_w00_c800",
    "cg2_l20_w25_c000", "cg2_l20_w25_c200", "cg2_l20_w25_c400",
    "cg2_l20_w50_c000", "cg2_l20_w50_c200", "cg2_l20_w50_c400",
    "cg3_l20_w00_c200", "cg3_l20_w00_c400", "cg3_l20_w00_c800",
    "cg3_l20_w25_c000", "cg3_l20_w25_c200", "cg3_l20_w25_c400",
    "cg3_l20_w50_c000", "cg3_l20_w50_c200", "cg3_l20_w50_c400",
    "cg4_l20_w00_c200", "cg4_l20_w00_c400", "cg4_l20_w00_c800",
    "cg4_l20_w25_c000", "cg4_l20_w25_c200", "cg4_l20_w25_c400",
    "cg4_l20_w50_c000", "cg4_l20_w50_c200", "cg4_l20_w50_c400",
]

submit("src/maxstab/exp-03-cluster.jl", FUNCS, PROBLEMS)
