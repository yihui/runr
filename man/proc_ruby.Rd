% Please edit documentation in R/ruby.R
\name{proc_ruby}
\alias{proc_ruby}
\title{Run a Ruby process}
\usage{
proc_ruby(port = 2000)
}
\arguments{
\item{port}{A TCP port number}
}
\value{
A list of functions \code{start()}, \code{exec()}, \code{running()}
  (check if the process has been running), and \code{stop()}.
}
\description{
This function returns a list of functions to start/run/stop a Ruby process.
The code is sent to Ruby via a socket connection, and the results are
written back in another socket connection.
}
\examples{
\dontrun{
rb = proc_ruby()
rb$start()
rb$exec("1 + 1")
rb$exec("a = 1..8", "a")  # return nothing
rb$exec("print a.inject(:+)")  # 36
rb$running()  # should be TRUE
rb$stop()
}
}
