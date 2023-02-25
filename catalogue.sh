#!/usr/bin/env bash

source common.sh

PRINT "Install NodeJS\t\t"
yum install nodejs make gcc-c++ npm -y &>>$LOG
STAT_CHECK $?

PRINT "Add Roboshop User\t"
id roboshop &>>$LOG
if [ $? -ne 0 ]; then
  useradd roboshop
fi
STAT_CHECK $?

PRINT "Download Application Code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG
STAT_CHECK $?

PRINT "Extract Application Code"
cd /home/roboshop && unzip -o /tmp/catalogue.zip &>>$LOG && rm -rf catalogue && mv catalogue-main catalogue
STAT_CHECK $?

PRINT "Install Code Dependencies"
cd /home/roboshop/catalogue && npm install --unsafe-perm &>>$LOG
STAT_CHECK $?

PRINT "Fix Permissions\t\t"
chown -R roboshop:roboshop /home/roboshop &>>$LOG
STAT_CHECK $?

PRINT "Setup SystemD file\t"
sed -i -e 's/MONGO_DNSNAME/localhost/' /home/roboshop/catalogue/systemd.service &>>$LOG && mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
STAT_CHECK $?

PRINT "Start Catalogue Service\t"
systemctl daemon-reload &>>$LOG && systemctl enable catalogue &>>$LOG  && systemctl start catalogue&>>$LOG
STAT_CHECK $?

