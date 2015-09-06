#' Run a matlab process
#'
#' This function returns a list of functions to start/run/stop a matlab process.
#' The code is sent to matlab via a socket connection, and the results are
#' written back in another socket connection.
#' @param port A TCP port number
#' @return A list of functions \code{start()}, \code{exec()}, \code{running()}
#'   (check if the process has been running), and \code{stop()}.
#' @export
#' @examples \dontrun{
#' mat = proc_matlab()
#' mat$start()
#' mat$exec('1+1')
#' mat$exec('x = 1 + 1; x = x + x; x;') # return nothing
#' mat$exec('x = 1 + 1\n x = x + x\n x') # return nothing
#' mat$exec('5:9') # [     5     6     7     8     9]
#' mat$exec('x = 1; while x < 10\n disp(x);\n x = x + 1;\n end') #Prints numbers 1 to 9
#' mat$running() # should be TRUE
#' mat$stop()
#' }

proc_matlab <- function(port = 6011){
  matlab <- NULL
  exec_code = function(...){
    if (is.null(matlab)) stop('the process has not been started yet')
    code = as.character(c(...))
    result = sapply(code, function(x) R.matlab::evaluatec(matlab, x))
    return(do.call(paste, c(as.list(result), sep = "\n")))
  }

  list(
    start = function() {
      if (!is.null(matlab)) {
        warning('the program has been started')
        return(invisible())
      }
      R.matlab::Matlab$startServer(port=port)
      matlab <<- R.matlab::Matlab(port=port)
      isOpen = open(matlab, trials=30, interval = 0, timeout = 1)
      if(!isOpen)
      {
        stop("Unable to connect to matlab server")
      }
      invisible()
    },

    exec = exec_code,

    running = function() !is.null(matlab),

    stop = function() {
      close(matlab)
      matlab <<- NULL
      invisible()
    }
  )
}


