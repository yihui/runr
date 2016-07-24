#' Run a Ruby process
#'
#' This function returns a list of functions to start/run/stop a Ruby process.
#' The code is sent to Ruby via a socket connection, and the results are
#' written back in another socket connection.
#' @param port A TCP port number
#' @return A list of functions \code{start()}, \code{exec()}, \code{running()}
#'   (check if the process has been running), and \code{stop()}.
#' @export
#' @examples \dontrun{
#' rb = proc_ruby()
#' rb$start()
#' rb$exec("1 + 1")
#' rb$exec("a = 1..8", "a")  # return nothing
#' rb$exec("print a.inject(:+)")  # 36
#' rb$running()  # should be TRUE
#' rb$stop()
#' }

proc_ruby <- function(port = 2000){
  if (Sys.which('ruby') == '') stop('Ruby was not installed or not in PATH')
  started <- FALSE
  sep = rand_string()
  exec_code = function(...){
    if (!started) stop('the process has not been started yet')
    code = paste(c(...), collapse = "\n")
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
      ruby_sock = system.file('lang', 'ruby_socket.rb', package = 'runr')
      system(sprintf('ruby %s %s %s %s', shQuote(ruby_sock), port, shQuote(token), sep), wait = FALSE)
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
      exec_code('exit')
      started <<- FALSE
      invisible()
    }
  )
}
