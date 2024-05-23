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

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LogFile
Validate $? "Downloading the cart application"

cd /app &>> $LogFile
Validate $? "changing the directory to app"

unzip -o /tmp/cart.zip &>> $LogFile
Validate $? "Unzipping cart"

npm install &>> $LogFile
Validate $? "Installing dependencies"

cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service &>> $LogFile
Validate $? "Copying cart service file"

systemctl daemon-reload &>> $LogFile
Validate $? "cart daemon-reload"

systemctl enable cart &>> $LogFile
Validate $? "enable cart"

systemctl start cart &>> $LogFile
Validate $? "start cart"





