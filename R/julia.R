#' Run a Julia process
#'
#' This function returns a list of functions to start/run/stop a Julia process.
#' The code is sent to Julia via a socket connection, and the results are
#' written back in another socket connection.
#' @param port A TCP port number
#' @return A list of functions \code{start()}, \code{exec()}, \code{running()}
#'   (check if the process has been running), and \code{stop()}.
#' @export
#' @examples \dontrun{
#' j = proc_julia()
#' j$start()
#' j$exec('1+1')
#' j$exec('a=[1:8]', 'a+5')
#' j$running() # should be TRUE
#' j$stop()
#' }
proc_julia = function(port = 2000) {

  sep = rand_string()
  started = FALSE
  exec_code = function(...) {
    if (!started) stop('the process has not been started yet')
    code = as.character(c(...))
    s = socketConnection(port = port, open = 'w', blocking = TRUE)
    writeLines(code, s)
    close(s)
    s = socketConnection(port = port, open = 'r', blocking = TRUE)
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
      julia_sock = system.file('lang', 'julia_socket.jl', package = 'runr')
      system(sprintf('julia %s %s %s %s', shQuote(julia_sock), port, shQuote(token), sep),
             wait = FALSE)
      while (!file.exists(token)) {
        # wait for the program to start up
        Sys.sleep(.05)
      }
      started <<- TRUE
      invisible()
    },

    exec = exec_code,

    running = function() started,

    stop = function() {
      exec_code('quit()')
      started <<- FALSE
    }
  )
}
