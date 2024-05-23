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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LogFile
Validate $? "Downloading erlang"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LogFile
Validate $? "Downloading rabbitmq server"

dnf install rabbitmq-server -y &>> $LogFile
Validate $? "insatalling rabbitmq server"

systemctl enable rabbitmq-server &>> $LogFile
Validate $? "enabling rabbitmq server"

systemctl start rabbitmq-server &>> $LogFile
Validate $? "start rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>> $LogFile
Validate $? "create own user and password"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LogFile
Validate $? "Setting permissions to new user"
