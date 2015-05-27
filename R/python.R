#' Run a Python process
#'
#' This function returns a list of functions to start/run/stop a Python process.
#' The code is sent to Python via a socket connection, and the results are
#' written back in another socket connection.
#' @param port A TCP port number
#' @return A list of functions \code{start()}, \code{exec()}, \code{running()}
#'   (check if the process has been running), and \code{stop()}.
#' @export
#' @examples \dontrun{
#' py = proc_python()
#' py$start()
#' py$exec('1+1')
#' py$exec('import numpy as np', 'a=np.arange(5)', 'a+5') # return nothing
#' py$exec('print a+5') # [5 6 7 8 9]
#' py$running() # should be TRUE
#' py$stop()
#' }

proc_python <- function(port = 6011){
  if (Sys.which('python') == '') stop('Python was not installed or not in PATH')
  started <- FALSE
  sep = rand_string()
  exec_code = function(...){
    if (!started) stop('the process has not been started yet')
    code = as.character(c(...))
    s = socketConnection(port = port, open = 'r+', blocking = TRUE, server = FALSE)
    writeLines(code, s)
    on.exit(close(s))
    split_results(readLines(s), sep)
  }

  list(
    start = function() {
      if (started) {
        warning('the program has been started')
        return(invisible())
      }
      token = tempfile()
      on.exit(unlink(token))
      python_sock = system.file('lang', 'python_scoket.py', package = 'runr')
      system(sprintf('python %s %s %s %s', shQuote(python_sock),
                     port, shQuote(token), sep), wait = FALSE)
      started <<- TRUE
      invisible()
    },

    exec = exec_code,

    running = function() started,

    stop = function() {
      exec_code('quit()')
      started <<- FALSE
      invisible()
    }
  )
}


