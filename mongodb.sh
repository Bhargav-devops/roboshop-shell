#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\E[33m"
N="\e[0m"

TimeStamp=$(date +%F-%H-%M-%S)
LogFile="/tmp/$0-$TimeStamp.log"

echo " Script starte executing at $TimeStamp " &>> $LogFile

Validate(){
    if [ $1 -ne 0 ]
    then 
        echo -e " $2 $R failed $N "
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
cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LogFile
Validate $? " copy mongodb repo "
