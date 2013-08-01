#!/bin/bash

# $1 is the fifo to read commands; $3 is another fifo to write the results
# $2 is a temporary file to hold the output, otherwise `>` will wipe out $3 if
# if redirect to $3 directly

trap "rm -f $1 $2 $3" EXIT

[ ! -p $1 ] && mkfifo $1
[ ! -p $3 ] && mkfifo $3

while true
do
  source $1 &> $2
  # I spent a whole day figuring out this weird solution: I have to write to $3
  # once before R/readLines() can read $3. Why?!!
  echo > $3
  cat $2 > $3
done
