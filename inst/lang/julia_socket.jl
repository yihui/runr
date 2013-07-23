# ARGS: {port, token_file, separator}

server = listen(int(ARGS[1]))
m = Module(:__anon__)

# a token indicating Julia has started
close(open(ARGS[2], "w"))

while true
  sock = accept(server)
  io = IOBuffer()
  s = readlines(sock)
  i = 1; x = ""
  while i <= length(s)
    if s[i] == "quit()"
      quit()
    end
    x = x * s[i]
    i += 1
    # nothing to parse here
    if ismatch(r"^\s*$", x)
      print(io, x)
      continue
    end
    ex = parse(x)
    if isa(ex, Expr) && ex.head === :continue
      continue
    end
    print(io, x)
    x = ""
    println(io, ARGS[3])
    val = eval(m, ex)
    if val != nothing; println(io, val); end
    println(io, ARGS[3])
  end
  close(sock)
  sock = accept(server)
  seekstart(io)
  write(sock, readall(io))
  close(sock)
  close(io)
end
