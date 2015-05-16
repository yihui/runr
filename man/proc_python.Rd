% Please edit documentation in R/python.R
\name{proc_python}
\alias{proc_python}
\title{Run a Python process}
\usage{
proc_python(port = 6011)
}
\arguments{
\item{port}{A TCP port number}
}
\value{
A list of functions \code{start()}, \code{exec()}, \code{running()}
  (check if the process has been running), and \code{stop()}.
}
\description{
This function returns a list of functions to start/run/stop a Python process.
The code is sent to Python via a socket connection, and the results are
written back in another socket connection.
}
\examples{
\dontrun{
py = proc_python()
py$start()
py$exec("1+1")
py$exec("import numpy as np", "a=np.arange(5)", "a+5")
py$running()  # should be TRUE
py$stop()
}
}
