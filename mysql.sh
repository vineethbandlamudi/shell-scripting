#!/usr/bin/env bash

source common.sh

PRINT "Setup MySQL Repo"
echo '[mysql57-community]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/$basearch/
enabled=1
gpgcheck=0' > /etc/yum.repos.d/mysql.repo
STAT_CHECK $?

PRINT "Install MySQL\t"
yum install mysql-community-server -y &>> $LOG
STAT_CHECK $?

PRINT "Start MySQL Service"
systemctl enable mysqld &>>$LOG && systemctl start mysqld &>>$LOG
STAT_CHECK $?

PRINT "Reset MySQL Temp Password"
TEMP_PASS=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" | mysql -uroot -p${TEMP_PASS} &>>$LOG
STAT_CHECK $?