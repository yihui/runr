#' Run a Bash process
#'
#' This function returns a list of functions to start/run/stop a Bash process.
#' The communication between R and Bash is through a socket.
#' @return A list of functions.
#' @author Yihui Xie and Yixuan Qiu (converted to use sockets by Adam Lyon)
#' @export
#' @examples \dontrun{
#' b=proc_bash(port=2000, passwd="abcd")
#' b$start()
#' b$exec('x=1')
#' b$exec('echo $x')
#' b$exec('echo $x--$x--$x')
#' b$exec("x=abcABC123ABCabc", "echo `expr length $x`  # length of x")
#' b$exec('foo bar')  # an error
#' b$running()
#' b$stop()
#' }
proc_bash = function(port=2000, passwd="abcd") {
  if (!capabilities('sockets'))
    stop('your platform does not support sockets')

  started = FALSE
  exec_code = function(...) {
    if (!started) stop('the process has not been started yet')
    code = c(...)
    s = socketConnection(port=port, open='w', blocking=TRUE)
    writeLines(c(passwd, code), s)
    close(s)
    if (identical(code, 'exit')) return(character(0))
    Sys.sleep(0.01)
    t = socketConnection(port=port, open='r', server=TRUE, blocking=TRUE)
    on.exit(close(t))
    out = readLines(t)
    new_results(code, gsub('^tmp2: ', '', out))
  }
  list(
    start = function() {
      if (started) {
        warning('the program has been started')
        return(invisible())
      }
      token = tempfile()
      bash_server = system.file('lang', 'bash_socket.bash', package = 'runr')
      system(paste(c(
        'bash', shQuote(bash_server), shQuote(token), port, passwd,
        mktemp(), mktemp(), mktemp()
      ), collapse = ' '), wait = FALSE)
      # this is not rigorous, because we really need to know if f1 is a fifo (it
      # does not suffice to exist)
      while(!file.exists(token)) Sys.sleep(0.05)
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

mktemp = function(...) shQuote(tempfile(...))
