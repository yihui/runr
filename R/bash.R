#' Run a Bash process
#'
#' This function returns a list of functions to start/run/stop a Bash process.
#' The communication between R and Bash is through a FIFO (named pipe), which
#' may not be supported under some operating systems.
#' @return A list of functions.
#' @author Yihui Xie and Yixuan Qiu
#' @export
#' @examples \dontrun{
#' b=proc_bash()
#' b$start()
#' b$exec('x=1')
#' b$exec('echo $x')
#' b$exec('echo $x--$x--$x')
#' b$exec("x=abcABC123ABCabc", "echo `expr length $x`  # length of x")
#' b$exec('foo bar')  # an error
#' b$running()
#' b$stop()
#' }
proc_bash = function() {
  if (!capabilities('fifo'))
    stop('your platform does not support FIFO')

  f1 = basename(tempfile('bash_fifo_in_', '.'))  # the fifo to write commands to bash
  f2 = tempfile('bash_tmp_', '.')  # a temporary file
  f3 = tempfile('bash_fifo_out_', '.')  # another fifo to collect results from f1
  started <<- FALSE
  exec_code = function(...) {
    if (!started) stop('the process has not been started yet')
    code = c(...)
    writeLines(code, f1)
    out = if (identical(code, 'exit')) character(0) else readLines(f3)
    new_results(code, gsub(paste('^', f1, ': ', sep = ''), '', out))
  }
  list(
    start = function() {
      if (started) {
        warning('the program has been started')
        return(invisible())
      }
      bash_fifo = system.file('lang', 'bash_fifo.sh', package = 'runr')
      system(sprintf('bash %s %s %s %s', shQuote(bash_fifo), f1, f2, f3), wait = FALSE)
      # this is not rigorous, because we really need to know if f1 is a fifo (it
      # does not suffice to exist)
      while(!file.exists(f1)) Sys.sleep(0.05)
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
