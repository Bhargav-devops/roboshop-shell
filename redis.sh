#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TimeStamp=$(date +%F-%H-%M-%S)
LogFile="/tmp/$0-$TimeStamp.log"
exec &>$LogFile

echo " Script starte executing at $TimeStamp"

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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
Validate $? "installing remi-release-8 "

dnf module enable redis:remi-6.2 -y
Validate $? "enable redis"

dnf install redis -y
Validate $? "installing redis "

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
Validate $? "allowing remote connection "

systemctl enable redis
Validate $? "installing remi-release-8 "

systemctl start redis
Validate $? "start redis"



