# runr

This is an R package providing mechanisms to run with external programs such
as Julia, Shell, and Python, etc. The basic idea is to open a background
process, pipe the source code into the process, evaluate it, and obtain the
printed results.

At the moment, there is only a simple Julia engine. Contributions welcome!

This package was originally designed for the [language
engines](http://yihui.name/knitr/demo/engines) in
[**knitr**](http://yihui.name/knitr), but it might be useful for more
general cases.
