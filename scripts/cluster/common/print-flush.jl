const MAJOR_SEP = "=" ^ 60
const MINOR_SEP = "-" ^ 60

struct FlushingIO{T} <: IO    # Auto-flush wrapper after print
    io::T
end

function Base.print(io::FlushingIO, args...)
    print(io.io, args...)
    flush(io.io)
end

print_flush(io::IO, args...) = print(FlushingIO(io), args...)
println_flush(io::IO, args...) = println(FlushingIO(io), args...)

print_flush(args...) = print_flush(stdout, args...)
println_flush(args...) = println_flush(stdout, args...)

function redirect_to_file(f, file)
    open(file, "a") do io
        redirect_stdout(f, io)
    end
end

print_title(title) = println_flush("$MAJOR_SEP\n  $title\n$MINOR_SEP\n")
print_sep() = println_flush("\n$MINOR_SEP\n")
