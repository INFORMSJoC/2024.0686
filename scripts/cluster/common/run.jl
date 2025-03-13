const TIME_LIMIT = 3600.0
const PILOT_TIME_LIMIT = 60.0

function run_experiment(exp_func, prob_file, log_file, result_file, rng_seed; time_limit=TIME_LIMIT)
    mkpath(dirname(log_file))
    mkpath(dirname(result_file))

    redirect_to_file(log_file) do
        try
            prob_stub = make_stub(prob_file)
            print_title("$exp_func on $prob_stub")

            # Model
            result = Dict(
                :func => string(exp_func),
                :prob => prob_stub,
                :rng_seed => rng_seed
            )
            preprocess_time = result[:preprocess_time] = @elapsed begin
                println_flush("Preprocessing...")
                model = exp_func(prob_file, result)
            end

            # Optimize
            print_sep()
            set_time_limit_sec(model, max(time_limit - preprocess_time, 60.0))
            optimize!(model)

            # Summarize
            print_sep()
            summarize!(result, model)
            write_result(result, result_file)
        catch ex
            showerror(stdout, ex, catch_backtrace())
        end
    end
end

function run_pilot(exp_func, prob_file, log_file; time_limit=PILOT_TIME_LIMIT)
    mkpath(dirname(log_file))
    
    redirect_to_file(log_file) do
        try
            prob_stub = make_stub(prob_file)
            print_title("PILOT - $exp_func on $prob_stub")

            # Model
            println_flush("Preprocessing...")
            model = exp_func(prob_file, Dict(:rng_seed => 0))

            # Optimize
            print_sep()
            set_time_limit_sec(model, time_limit)
            optimize!(model)
        catch ex
            showerror(stdout, ex, catch_backtrace())
        end
    end
end

function write_result(result, result_file)
    json = JSON.json(result)
    write(result_file, json)
end