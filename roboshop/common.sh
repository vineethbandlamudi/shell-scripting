#!/bin/bash

USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]; then
    echo -e "\e[31mYou should be a root user to run this\e{0m"
    exit 2
fi

LOG=/tmp/roboshop.log
rm -f $LOG

STAT_CHECK() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSuccess\e[0m"
  else
    echo -e "\e[31mFailure\e[0m"
    exit 1
}


PRINT() {
  echo -n -e "$1\t\t..."
}

