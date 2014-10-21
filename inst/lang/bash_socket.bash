#!/bin/bash
#
# Server for bash <--> R
#
port=$1
passwd=$2

while true
do
  # Listen for data
  nc -l $port > tmp

  # Check password
  passwdSent=$(head -n 1 tmp)

  if [ "$passwdSent" == "quit" ]
  then
    break
  elif [ "$passwdSent" == "$passwd" ]
  then
    tail -n +2 tmp > tmp2
    source tmp2 >& tmp3
  else
    echo "Bad Password" > tmp3
  fi

  # See http://bit.ly/1vDblqg and http://bit.ly/1wruCeh
  until exec 6<>/dev/tcp/127.0.0.1/$port; do
  sleep 1
  done
  cat tmp3 >&6
  exec 6>&-  # Close
  done

rm -f tmp tmp2 tmp3
```
