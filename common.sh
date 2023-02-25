#!/usr/bin/env bash

USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]; then
  echo -e "\e[31mYou must be a root user\e[0m"
  exit 2
fi

LOG=/tmp/roboshop.log
rm -rf $LOG

PRINT() {
  echo -n -e "$1\t\t..."
}

STAT_CHECK() {
  if [ $1 -eq 0 ]; then
    echo "Done"
  else
    echo "Fail"
    exit 1
  fi
}