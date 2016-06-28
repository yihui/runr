# ARGS: {port, token_file, separator}

## Declare global variables as const as that helps type inference
const server = listen(parse(Int, ARGS[1]))
const io = IOBuffer()

## Touch the file indicating that Julia has started
touch(ARGS[2])

## Write the connection handler as a function so that it will be
## compiled and to avoid creating nonconst global variables.

function serve(server::Base.TCPServer)
    sock = accept(server)
    s = readlines(sock)
    i = 1; x = ""
    while i <= length(s)
        if s[i] == "quit()"
            quit()
        end
        x = x * s[i]
        i += 1

        if ismatch(r"^\s*$", x)  ## nothing to parse here
            print(io, x)
            continue
        end
        ex = parse(x)
        if isa(ex, Expr) && ex.head === :incomplete
            continue
        end
        print(io, x)
        x = ""
        println(io, ARGS[3])
        val = eval(ex)
        val == nothing || println(io, repr(val))
        println(io, ARGS[3])
    end
    close(sock)
    sock = accept(server)
    write(sock,takebuf_string(io))
    close(sock)
end

while true
    serve(server)
end
