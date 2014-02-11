# generate a random string
CHARS = c(letters, LETTERS, 0:9)
rand_string = function(len = 32) {
  paste(sample(CHARS, len, replace = TRUE), collapse = '')
}

# split code and output
split_results = function(x, sep) {
  x = strsplit(paste(x, collapse = '\n'), sep)[[1]]
  res = vector('list', length(x))
  for (i in seq_along(x)) {
    el = gsub('^\n+|\n+$', '', x[i])
    res[[i]] = if (i %% 2 == 1) new_source(el) else paste(el, collapse = '\n')
  }
  structure(res, class = c('runr_results', 'list'))
}

# construct a list of results of the class runr_results
new_results = function(src, out) {
  structure(list(new_source(src), paste(out, collapse = '\n')),
            class = c('runr_results', 'list'))
}

new_source = function(src) structure(list(src = src), class = 'source')

#' @S3method print runr_results
print.runr_results = function(x, comment = '# ') {
  for (i in seq_along(x)) {
    is.src = inherits(x[[i]], 'source')
    el = if (is.src) x[[i]][['src']] else x[[i]]
    if (length(el) == 0 || identical(el, '')) next
    if (!is.src)
      el = paste(comment, unlist(strsplit(el, '\n')), sep = '', collapse = '\n')
    cat(el, sep = '\n')
  }
}
