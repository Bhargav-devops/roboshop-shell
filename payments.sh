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

dnf install python36 gcc python3-devel -y

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

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LogFile
Validate $? "downloading python application"

cd /app 
Validate $? "changing the app directory"

unzip -o /tmp/payment.zip &>> $LogFile
Validate $? "unzip the payment app"

pip3.6 install -r requirements.txt &>> $LogFile
Validate $? "insatalling python dependencies"

cp home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service  
Validate $? "copying the payment.service to etc"

systemctl daemon-reload &>> $LogFile
Validate $? "daemon Reload"

systemctl enable payment &>> $LogFile
Validate $? "enable payment"

systemctl start payment &>> $LogFile
Validate $? "start payment"
