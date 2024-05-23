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

dnf install nginx -y &>> $LogFile
Validate $? "Installing ngix"

systemctl enable nginx 
Validate $? "enable ngix"

systemctl start nginx &>> $LogFile
Validate $? "start nginx"

rm -rf /usr/share/nginx/html/* &>> $LogFile
Validate $? "removing default ngix html"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LogFile
Validate $? "Downloading web application"

cd /usr/share/nginx/html
Validate $? "change directory"

unzip -o /tmp/web.zip
Validate $? "unzip web applization"

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf 
Validate $? "copying roboshop conf into etc"

systemctl restart nginx &>> $LogFile
Validate $? "restart ngix"