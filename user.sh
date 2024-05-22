#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TimeStamp=$(date +%F-%H-%M-%S)
LogFile="/tmp/$0-$TimeStamp"
Mongodb_Host=mongo.bhargavdevops.online

echo " Script starte executing at $TimeStamp " &>> $LogFile

Validate(){
if [ $1 -ne 0 ]
then
    echo -e " $2 $R failed $N "
    exit 1
else
    echo -e " $3 $G success $N "
if
}


if [ $ID -ne 0 ]
then
    echo -e "login as a $R root user to run the script $N"
    exit 1
else
    echo -e " you are root user"
fi

dnf module disable nodejs -y $>> $LogFile
Validate $? "diabled nodejs"

dnf module enable nodejs:18 -y $>> $LogFile
Validate $? "enable nojes 18 "

dnf install nodejs -y
Validate $? "install nojes 18 "

id roboshop
if [ $? -ne 0 ]
then
    echo -e " $Y creating user $N"
    useradd roboshop
else 
    echo -e " user already $G created $N"
fi
mkdir -p /app $>> $LogFile
Validate $? "created app directory  "


curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip $>> $LogFile
Validate $? "Downloading the user application"

cd /app 

unzip -o /tmp/user.zip &>> $LogFile
Validate $? "Unzip the application"

npm install $>> $LogFile
Validate $? "Installing Dependencies"

cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service $>> $LogFile
Validate $? "copied the user service "

systemctl daemon-reload &>> $LogFile
Validate $? "Daemon reload "

systemctl enable user &>> $LogFile
Validate $? "enable user "

systemctl start user &>> $LogFile
Validate $? "start user service "

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LogFile
Validate $? "copying mongo repo"

dnf install mongodb-org-shell -y &>> $LogFile
Validate $? "install mongodb client "

mongo --host $Mongodb_Host </app/schema/user.js
Validate $? "copied the user service "



