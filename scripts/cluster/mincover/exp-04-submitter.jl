include("../common/submitter.jl")

using Printf

PROBLEM_DIR = "problems/mincover/expset-4"
PREFIXES = [@sprintf("mcp4-n%03d-r%02d", n, r) for n in 70:10:120, r in [8, 10, 12, 14, 16]]

PROBLEMS = joinpath.([PROBLEM_DIR], PREFIXES)

vf_name(w) = @sprintf("vf_w%02d", w)
dp_name(w) = @sprintf("dp_w%03d", w)

FUNCS = [
    [vf_name(w) for w in [0]]...,
    [dp_name(w) for w in [50, 100, 150, 200, 250, 300]]...,
]

RUNS = [
    ("dp_w100", "mcp4-n110-r14"),
    ("dp_w100", "mcp4-n120-r14"),
    ("dp_w100", "mcp4-n070-r16"),
    ("dp_w100", "mcp4-n080-r16"),
    ("dp_w100", "mcp4-n090-r16"),
]

uuid = uuid1()
for (f, p) in RUNS
    pp = joinpath(PROBLEM_DIR, p)
    submit("src/mincover/exp-04-cluster.jl", [f], [pp]; time="24:00:00", uuid)
end
