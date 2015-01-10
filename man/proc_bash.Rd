% Please edit documentation in R/bash.R
\name{proc_bash}
\alias{proc_bash}
\title{Run a Bash process}
\usage{
proc_bash(port = 2000)
}
\arguments{
\item{port}{A TCP port number}
}
\value{
A list of functions.
}
\description{
This function returns a list of functions to start/run/stop a Bash process.
The communication between R and Bash is through a socket.
}
\examples{
\dontrun{
b = proc_bash()
b$start()
b$exec("x=1")
b$exec("echo $x")
b$exec("echo $x--$x--$x")
b$exec("x=abcABC123ABCabc", "echo `expr length $x`  # length of x")
b$exec("foo bar")  # an error
b$running()
b$stop()
}
}
\author{
Originally implemented via FIFO by Yihui Xie and Yixuan Qiu;
  converted to use sockets by Adam Lyon.
}
