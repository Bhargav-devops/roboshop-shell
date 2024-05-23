#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TimeStamp=$(date +%F-%H-%M-%S)
LogFile="/tmp/$0-$TimeStamp.log"

echo " Script starte executing at $TimeStamp " &>> $LogFile

Validate(){
    if [ $1 -ne 0 ]
    then 
        echo -e " $2 $R failed $N "
        exit 1
    else 
        echo -e " $2  $G success $N "
    fi
}

if [ $ID -ne 0 ]
then
    echo -e " $R Error: Please login as root user to install $N"
    exit 1
else
    echo -e "you are root user"
fi

dnf module disable mysql -y &>> $LogFile
Validate $? "disable current mysql version"

cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo
Validate $? "copying mysql repo to etc folder"

dnf install mysql-community-server -y &>> $LogFile
Validate $? "installing mysql"

systemctl enable mysqld &>> $LogFile
Validate $? "installing mysql"

systemctl start mysqld &>> $LogFile
Validate $? "installing mysql"

mysql_secure_installation --set-root-pass RoboShop@1
Validate $? "changing deafult root password for mysql"

