#!/bin/bash

#aws ec2 run-instances --image-id ami-0f3c7d07486cad139 --instance-type t2.micro --security-group-ids sg-01d0fa686e2d4cfbc --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=i}]"

AMI="ami-0f3c7d07486cad139"
SG_ID="sg-01d0fa686e2d4cfbc"
Instances=("mongodb" "mysql" "shipping" "catalogue" "cart" "user" "redis" "payment" "rabbitmq" "dispatch" "web")
for i in "${Instances[@]}"
do
    echo "instance $i"
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then
        InstanceType="t3.small"
    else
        InstanceType="t2.micro"
    fi
aws ec2 run-instances --image-id $AMI --instance-type $InstanceType --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]"
done