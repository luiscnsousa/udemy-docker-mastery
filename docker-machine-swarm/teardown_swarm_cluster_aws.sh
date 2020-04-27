#!/bin/bash
set -e 

SWARM_NODES=3

for ((ID=1;ID<=$SWARM_NODES;ID++))
do
    docker-machine rm --force "swarm-aws$ID"
done

echo "---------------"
echo "Docker machines"
echo "---------------"
docker-machine ls