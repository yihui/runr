\name{proc_bash}
\alias{proc_bash}
\title{Run a Bash process}
\usage{
proc_bash(port=2000, passwd="abcd")
}
\arguments{
\item{port}{A TCP port number}
\item{passwd}{For added security, send along a secret word with the command.}
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
b = proc_bash(port=2000, passwd="bob")
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
