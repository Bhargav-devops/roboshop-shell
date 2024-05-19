#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TimeStamp=$(date +%F-%H-%M-%S)
LogFile="/tmp/$0-$TimeStamp.log"
Mongodb_Host="mongodb.bhargavdevops.online"

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

dnf module disable nodejs -y &>> $LogFile
Validate $? "disable nodejs"

dnf module enable nodejs:18 -y &>> $LogFile
Validate $? "enable nodejs"

dnf install nodejs -y &>> $LogFile
Validate $? "installing nodejs"

id roboshop &>> $LogFile
if [ $? -ne 0 ]
then
    useradd roboshop &>> $LogFile
    Validate $? "creating roboshop user "
else
    echo -e "user already exist $Y skipping $N"
fi
mkdir -p /app &>> $LogFile
Validate $? "creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LogFile
Validate $? "Downloading the catalogue application"

cd /app &>> $LogFile
Validate $? "changing the directory to app"

unzip -o /tmp/catalogue.zip &>> $LogFile
Validate $? "Unzipping catalogue"

npm install &>> $LogFile
Validate $? "Installing dependencies"

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>> $LogFile
Validate $? "Copying catalogue service file"

systemctl daemon-reload &>> $LogFile
Validate $? "catalogue daemon-reload"

systemctl enable catalogue &>> $LogFile
Validate $? "enable catalogue"

systemctl start catalogue &>> $LogFile
Validate $? "start catalogue"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LogFile
Validate $? "copying mongo repo"

dnf install mongodb-org-shell -y &>> $LogFile
Validate $? "copying mongo repo"

mongo --host $Mongodb_Host </app/schema/catalogue.js &>> $LogFile
Validate $? "loading catalogue data into mongodb"






