using UUIDs

include("names.jl")

function make_script(cluster_script, exp_func, prob_prefix, uuid;
    time="6:00:00", mem="8G", account="def-mxm")

    script_file = script_file_name("jobs", string(uuid), exp_func, prob_prefix)
    output_file = output_file_name("jobs", string(uuid), exp_func, prob_prefix)

    mkpath(dirname(script_file))
    mkpath(dirname(output_file))

    open(script_file, "w") do io
        print(io, """
        #!/bin/bash
        #SBATCH --time=$time
        #SBATCH --mem=$mem
        #SBATCH --account=$account
        #SBATCH --output=$output_file
        module load StdEnv/2020 julia/1.8.5 gurobi/9.5
        julia $cluster_script $exp_func $prob_prefix $uuid
        """)
    end

    return script_file
end

function submit(cluster_script, funcs, probs;
    time="6:00:00", mem="8G", account="def-mxm", uuid=uuid1())

    ids_file = joinpath("jobs", string(uuid), "job_ids.txt")
    mkpath(dirname(ids_file))

    open(ids_file, "a") do io
        for func in funcs, prob_prefix in probs
            stub = make_stub(prob_prefix)
            script = make_script(cluster_script, func, prob_prefix, uuid; time, mem, account)
            println("Submitting $script")
            out = read(`sbatch --parsable $script`, String)
            print(io, "$func; $stub; ")
            print(io, out)
            sleep(1)
        end
    end
end

function make_script2(cluster_script, exp_func, uuid, probs;
    time="12:00:00", mem="8G", account="def-mxm")

    script_file = script_file_name("jobs", string(uuid), exp_func, probs[1])
    output_file = output_file_name("jobs", string(uuid), exp_func, probs[1])

    mkpath(dirname(script_file))
    mkpath(dirname(output_file))
    
    probs_flatten = join("\"" .* probs .* "\"", " ")

    open(script_file, "w") do io
        print(io, """
        #!/bin/bash
        #SBATCH --time=$time
        #SBATCH --mem=$mem
        #SBATCH --account=$account
        #SBATCH --output=$output_file
        module load julia/1.8.5 gurobi/9.5
        julia $cluster_script $exp_func $uuid $probs_flatten
        """)
    end

    return script_file
end

function submit2(cluster_script, funcs, probs;
    time="12:00:00", mem="8G", account="def-mxm", uuid=uuid1(), batch_size=10)

    ids_file = joinpath("jobs", string(uuid), "job_ids.txt")
    mkpath(dirname(ids_file))

    batches = Iterators.partition(probs, batch_size)

    open(ids_file, "a") do io
        for func in funcs, batch in batches
            stub = make_stub(batch[1])
            script = make_script2(cluster_script, func, uuid, batch; time, mem, account)
            println("Submitting $script")
            out = read(`sbatch --parsable $script`, String)
            print(io, "$func; $stub; ")
            print(io, out)
            sleep(1)
        end
    end
end
