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
    echo -e "\e[32m Done\e[0m"
  else
    echo -e "\e[31m Fail\e[0m"
    echo -e "\e[33m Check log file for more info - $LOG\e[0m"
    exit 1
  fi
}