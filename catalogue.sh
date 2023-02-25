#!/usr/bin/env bash

source common.sh

PRINT "Install NodeJS\t"
yum install nodejs make gcc-c++ -y  &>>$LOG
STAT_CHECK $?

PRINT "Add Roboshop User"
id roboshop &>>$LOG
if [ $? -ne 0 ]; then
  useradd roboshop
fi
STAT_CHECK $?

PRINT "Download Application Code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG
STAT_CHECK $?

PRINT "Extract Application Code"
cd /home/roboshop && unzip -o /tmp/catalogue.zip &>>$LOG
STAT_CHECK $?