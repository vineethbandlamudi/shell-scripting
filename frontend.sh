#!/usr/bin/bash

source common.sh

PRINT "Install Nginx"
yum install nginx -y &>>$LOG
STAT_CHECk $?

PRINT "Download Frontend"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
STAT_CHECk $1

PRINT "Remove old HtDocs"
cd /usr/share/nginx/html &>>$LOG && rm -rf * &>>$LOG
STAT_CHECk $1

PRINT "Extract Frontend Archive"
unzip /tmp/frontend.zip &>>$LOG && mv frontend-main/* . &>>$LOG && mv static/* . &>>$LOG && rm -rf frontend-master static &>>$LOG
STAT_CHECk $1

PRINT "Updarte Roboshop Config"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG
STAT_CHECk $1

PRINT "Enable Nginx"
systemctl enable nginx &>>$LOG
STAT_CHECk $?

PRINT "Start Nginx"
systemctl start nginx &>>$LOG
STAT_CHECk $?

