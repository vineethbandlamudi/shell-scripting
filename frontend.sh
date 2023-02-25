#!/usr/bin/bash

source common.sh

PRINT "Install Nginx"
yum install nginx -y &>>$LOG
STAT_CHECK $?

PRINT "Download Frontend"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG
STAT_CHECK $?

PRINT "Remove old HtDocs"
cd /usr/share/nginx/html &>>$LOG && rm -rf * &>>$LOG
STAT_CHECK $?

PRINT "Extract Frontend Archive"
unzip /tmp/frontend.zip &>>$LOG && mv frontend-main/* . &>>$LOG && mv static/* . &>>$LOG && rm -rf frontend-master static &>>$LOG
STAT_CHECK $?

PRINT "Updarte Roboshop Config"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG
STAT_CHECK $?

PRINT "Enable Nginx"
systemctl enable nginx &>>$LOG
STAT_CHECK $?

PRINT "Start Nginx"
systemctl start nginx &>>$LOG
STAT_CHECK $?

