using ZMQ

const ctx = Context(1)
const s = Socket(ctx, REP)
bind(s, "tcp://*:$ARGS[1]")

while true
    msg = bytestring(recv(s))
    @show msg # for debugging
    send(s, repr(eval(parse(msg))))
end
