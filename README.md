# runr

[![Build Status](https://travis-ci.org/yihui/runr.svg)](https://travis-ci.org/yihui/runr)

This is an R package providing mechanisms to run with external programs such
as Julia, Shell, and Python, etc. The basic idea is to open a background
process, pipe the source code into the process, evaluate it, and obtain the
printed results.

At the moment, there are only a few very simple engines:

- a [Julia](http://julialang.org/) engine ([using](inst/lang/julia_socket.jl)
  TCP sockets; [an example](http://rpubs.com/yihui/julia-knitr))
- a `bash` engine ([using](inst/lang/bash_socket.bash) TCP sockets; [an
  example](http://rpubs.com/yihui/bash-knitr))
- a `python` engine([using](inst/lang/python_socket.py) TCP sockets; [an example](http://rpubs.com/badbye/python-knitr))
- a `ruby` engine([using](inst/lang/ruby_socket.rb) TCP socketss; [an example](http://rpubs.com/y4ashida/ruby-knitr))

Contributions welcome!

This package was originally designed for the [language
engines](http://yihui.name/knitr/demo/engines) in
[**knitr**](http://yihui.name/knitr), but it might be useful for more
general cases.
