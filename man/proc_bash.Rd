\name{proc_bash}
\alias{proc_bash}
\title{Run a Bash process}
\usage{
proc_bash()
}
\value{
A list of functions.
}
\description{
This function returns a list of functions to start/run/stop a Bash process.
The communication between R and Bash is through a FIFO (named pipe), which
may not be supported under some operating systems.
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
Yihui Xie and Yixuan Qiu
}
