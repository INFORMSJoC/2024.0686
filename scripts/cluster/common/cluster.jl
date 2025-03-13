LOGS = "logs/"
RESULTS = "results/"

function run_cluster(func_str, prob_prefix, uuid; test=false, batch=5)
    exp_func = eval(Symbol(func_str))
    prob_files = prob_prefix .* "-" .* lpad.(1:batch, 2, '0') .* ".json"
    rng_seed = hash(uuid)
    time_limit = test ? 60. : TIME_LIMIT

    pilot_log = pilot_log_file_name(LOGS, uuid, exp_func, prob_prefix)
    println("Redirecting to $pilot_log")
    run_pilot(exp_func, first(prob_files), pilot_log)

    for prob_file in prob_files
        log_file = log_file_name(LOGS, uuid, exp_func, prob_file)
        result_file = result_file_name(RESULTS, uuid, exp_func, prob_file)
        println("Redirecting to $log_file")
        run_experiment(exp_func, prob_file, log_file, result_file, rng_seed; time_limit)
    end
end

function run_cluster2(func_str, uuid, prob_files...; test=false)
    exp_func = eval(Symbol(func_str))
    rng_seed = hash(uuid)
    time_limit = test ? 60. : TIME_LIMIT

    pilot_log = pilot_log_file_name(LOGS, uuid, exp_func, prob_files[1])
    println("Redirecting to $pilot_log")
    run_pilot(exp_func, first(prob_files), pilot_log)

    for prob_file in prob_files
        log_file = log_file_name(LOGS, uuid, exp_func, prob_file)
        result_file = result_file_name(RESULTS, uuid, exp_func, prob_file)
        println("Redirecting to $log_file")
        run_experiment(exp_func, prob_file, log_file, result_file, rng_seed; time_limit)
    end
end

function make_rng(seed, n)
    return [MersenneTwister(seed + i) for i in 0:(n-1)]
end
