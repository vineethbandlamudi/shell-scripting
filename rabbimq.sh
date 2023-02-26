#!/usr/bin/env bash

source common.sh

PRINT "Install Erlang"
if [  $? -ne 0 ]; then
  yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y  &>>$LOG
fi
STAT_CHECK $?

PRINT "Setup RabbitMQ Repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG
STAT_CHECK $?

PRINT "Install RabbitMQ"
yum install rabbitmq-server -y  &>>$LOG
STAT_CHECK $?

PRINT "Start RabbitMQ Service"
systemctl enable rabbitmq-server &>>$LOG &&  systemctl start rabbitmq-server &>>$LOG
STAT_CHECK $?

PRINT "Create Applcation User"
rabbitmqctl add_user roboshop roboshop123 &>>$LOG
STAT_CHECK $?



