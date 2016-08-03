#!/usr/bin/env ruby
# coding: utf-8

require 'socket'
require 'stringio'

port, token, sep = ARGV

host = '127.0.0.1'
server = TCPServer.open(host, port)

# Touch the file indicating that Ruby has started
File.open(token, 'w').close()

def capture_stdout
  out = StringIO.new
  $stdout = out
  yield
  return out.string
ensure
  $stdout = STDOUT
end

def exec(code)
  @binding ||= binding

  begin
    capture_stdout { eval(code, @binding) }
  rescue => e
    STDERR.puts e.message
  end
end

loop do
  socket = server.accept
  code = socket.recv(1024000)

  if code.strip == 'exit'
    socket.close
    break
  end

  output = exec(code)

  socket.puts [code, sep, output].join("\n")
  socket.close
end

server.close
