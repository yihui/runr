#!/bin/bash
#
# Server for bash <--> R
#

token=$1
port=$2
passwd=$3
tmp1=$4
tmp2=$5
tmp3=$6

touch $token

while true
do
  # Listen for data
  nc -l $port > $tmp1

  # Check password
  passwdSent=$(head -n 1 "$tmp1")

  if [ "$passwdSent" == "exit" ]
  then
    break
  elif [ "$passwdSent" == "$passwd" ]
  then
    tail -n +2 $tmp1 > $tmp2
    source $tmp2 >& $tmp3
  else
    echo "Bad Password" > $tmp3
  fi

  sleep 0.05

  # See http://bit.ly/1vDblqg and http://bit.ly/1wruCeh
  until exec 6<>/dev/tcp/localhost/$port; do
  sleep 0.05
  done
  cat $tmp3 >&6
  exec 6>&-  # Close
  done

rm -f $token $tmp1 $tmp2 $tmp3
