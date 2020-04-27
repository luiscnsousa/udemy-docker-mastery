#!/bin/bash
set -e 
echo "---------------------------"
echo "Docker Swarm cluster in AWS"
echo "---------------------------"

AWS_VPC="vpc-0b2428649eaeadfc0"
AWS_SUBNET="subnet-0cb10f830a33310aa"
AWS_REGION="eu-west-2"
AWS_ZONE="a"
AWS_INSTANCE="t2.micro"
AWS_SECURITYGRP="swarm-cluster"

echo "Virtual Private Cloud: $AWS_VPC"
echo "Subnet: $AWS_SUBNET"
echo "Region: $AWS_REGION"
echo "Availability Zone: $AWS_ZONE"
echo "Instance Type: $AWS_INSTANCE"
echo "Security Group: $AWS_SECURITYGRP"

SWARM_NODES=3
JOIN_PORT=2377
JOIN_IP=""
JOIN_TOKEN=""

for ((ID=1;ID<=$SWARM_NODES;ID++))
do
    echo "--------------------"
    echo "Creating node $ID of $SWARM_NODES"
    echo "--------------------"

    NODE_NAME="swarm-aws$ID"

    docker-machine create \
        --driver amazonec2 \
        --amazonec2-vpc-id $AWS_VPC \
        --amazonec2-subnet-id $AWS_SUBNET \
        --amazonec2-region $AWS_REGION \
        --amazonec2-zone $AWS_ZONE \
        --amazonec2-instance-type $AWS_INSTANCE \
        --amazonec2-security-group $AWS_SECURITYGRP \
        $NODE_NAME

    docker-machine ssh swarm-aws1 "getent group docker"
    docker-machine ssh swarm-aws1 "sudo gpasswd -a ubuntu docker"

    docker-machine env $NODE_NAME
    eval $(docker-machine env $NODE_NAME)

    if [[ $ID -eq 1 ]]
    then
        docker swarm init
        JOIN_IP=$(docker-machine inspect swarm-aws1 -f "{{ .Driver.PrivateIPAddress }}")
        JOIN_TOKEN=$(docker swarm join-token manager --quiet)
    else
        docker swarm join --token $JOIN_TOKEN $JOIN_IP:$JOIN_PORT
    fi

    echo "-----------"
    echo "Swarm nodes"
    echo "-----------"
    docker node ls

    eval $(docker-machine env -u)
done

echo "---------------"
echo "Docker machines"
echo "---------------"
docker-machine ls