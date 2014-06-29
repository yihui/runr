\name{proc_julia}
\alias{proc_julia}
\title{Run a Julia process}
\usage{
proc_julia(port = 2000)
}
\arguments{
\item{port}{A TCP port number}
}
\value{
A list of functions \code{start()}, \code{exec()}, \code{running()}
  (check if the process has been running), and \code{stop()}.
}
\description{
This function returns a list of functions to start/run/stop a Julia process.
The code is sent to Julia via a socket connection, and the results are
written back in another socket connection.
}
\examples{
\dontrun{
j = proc_julia()
j$start()
j$exec("1+1")
j$exec("a=[1:8]", "a+5")
j$running()  # should be TRUE
j$stop()
}
}
