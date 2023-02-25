#!/usr/bin/env bash

source common.sh

PRINT "Setup MongoDB Repo"
echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
STAT_CHECK $?

PRINT "Install MongoDB Service"
yum install -y mongodb-org  &>>$LOG
STAT_CHECK $?

PRINT "Updating Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG
STAT_CHECK $?

PRINT "Enable MongoDB Service"
systemctl enable mongod &>>$LOG
STAT_CHECK $?

PRINT "Start MongoDB Service"
systemctl start mongod &>>$LOG
STAT_CHECK $?

PRINT "Download Schema\t"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
STAT_CHECK $?

PRINT "Load Schema\t"
cd /tmp && unzip -o mongodb.zip &>>$LOG && cd mongodb-main && mongo < catalogue.js &>>$LOG && mongo < users.js &>>$LOG
STAT_CHECK $?