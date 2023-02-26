#!/usr/bin/env bash

USER_ID=$(id -u)
if [ "$USER_ID" -ne "0" ]; then
  echo -e "\e[31mYou must be a root user\e[0m"
  exit 2
fi

LOG=/tmp/roboshop.log
rm -rf $LOG

PRINT() {
  echo -n -e "$1\t\t..."
}

STAT_CHECK() {
  if [ "$1" -eq "0" ]; then
    echo -e "\e[32m Done\e[0m"
  else
    echo -e "\e[31m Fail\e[0m"
    echo -e "\e[33m Check log file for more info - $LOG\e[0m"
    exit 1
  fi
}

NODEJS() {
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
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG
  STAT_CHECK $?

  PRINT "Extract Application Code"
  cd /home/roboshop && unzip -o /tmp/${COMPONENT}.zip &>>$LOG && rm -rf ${COMPONENT} && mv ${COMPONENT}-main ${COMPONENT}
  STAT_CHECK $?

  PRINT "Install Code Dependencies"
  cd /home/roboshop/${COMPONENT} && npm install --unsafe-perm &>>$LOG
  STAT_CHECK $?

  PRINT "Fix Permissions\t\t"
  chown -R roboshop:roboshop /home/roboshop &>>$LOG
  STAT_CHECK $?

  PRINT "Setup SystemD file\t"
  sed -i -e 's/MONGO_DNSNAME/mongo.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/'  -e 's/MONGO_ENDPOINT/mongo.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>$LOG && mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
  STAT_CHECK $?

  PRINT "Start ${COMPONENT} Service\t"
  systemctl daemon-reload &>>$LOG && systemctl enable ${COMPONENT} &>>$LOG  && systemctl start ${COMPONENT}&>>$LOG
  STAT_CHECK $?
}