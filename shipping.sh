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

dnf install maven -y


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

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip
Validate $? "Downloading shipping application"

cd /app

unzip -o /tmp/shipping.zip &>> $LogFile
Validate $? "unzip shipping application"

mvn clean package &>> $LogFile
Validate $? "building the application"

mv target/shipping-1.0.jar shipping.jar &>> $LogFile
Validate $? "renaming the shipping jar"

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service 
Validate $? "copying shipping service to etc"

systemctl daemon-reload &>> $LogFile
Validate $? "daemon Reload"

systemctl enable shipping &>> $LogFile
Validate $? "enable shipping"

systemctl start shipping &>> $LogFile
Validate $? "start shipping"

dnf install mysql -y &>> $LogFile
Validate $? "installing mysql"

mysql -h mysql.bhargavdevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> $LogFile
Validate $? "loading shipping data"

systemctl restart shipping &>> $LogFile
Validate $? "restart shipping"
