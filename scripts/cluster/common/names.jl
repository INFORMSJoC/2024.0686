make_stub(prob_file) = splitext(basename(prob_file))[1]

log_file_name(log_dir, uuid, exp_func, prob_file) = joinpath(log_dir, uuid, string(exp_func), make_stub(prob_file) * ".txt")
result_file_name(result_dir, uuid, exp_func, prob_file) = joinpath(result_dir, uuid, string(exp_func), make_stub(prob_file) * ".json")

pilot_log_file_name(log_dir, uuid, exp_func, prob_prefix) = joinpath(log_dir, uuid, string(exp_func), make_stub(prob_prefix) * "-pilot.txt")

script_file_name(job_dir, uuid, exp_func, prob_file) = joinpath(job_dir, uuid, "scripts", string(exp_func), make_stub(prob_file) * ".sh")
output_file_name(job_dir, uuid, exp_func, prob_file) = joinpath(job_dir, uuid, "output", string(exp_func), make_stub(prob_file) * ".out")
