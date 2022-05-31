#!/bin/bash

source common.sh

PRINT "Install Nginx"
yum install nginx -y &>>$LOG
STAT_CHECK $?

PRINT "Download frontend"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
STAT_CHECK $?

PRINT "Remove old HTML Docs"
cd /usr/share/nginx/html && rm -rf * &>>$LOG
STAT_CHECK $?

PRINT "Extract Frontend"
unzip /tmp/frontend.zip &>>$LOG && mv frontend-main/* . && mv static/* . && rm -rf frontend-master static
STAT_CHECK $?

PRINT "Update Roboshop config"
mv localhost.conf /etc/nginx/default.d/roboshop.conf

PRINT "Enable Nginx"
systemctl start nginx &>>$LOG
STAT_CHECK $?

PRINT "Start Nginx"
systemctl restart nginx
STAT_CHECK $?
