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
    res[[i]] = if (i %% 2 == 1) structure(list(src = el), class = 'source') else el
  }
  res
}