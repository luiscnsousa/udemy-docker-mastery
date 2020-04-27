#!/bin/bash
set -e #Exit immediately if a command exits with a non-zero status.

#creates a VM with Docker with docker-machine using VirtualBox driver (needs docker-machine and virtualbox installed)
docker-machine create --driver virtualbox default

#execute docker commands on VM's docker instead of local docker
docker-machine env default
eval $(docker-machine env default)

#add ubuntu user of ssh session to the docker group
getent group docker
sudo gpasswd -a ubuntu docker

#revert back to local docker
eval $(docker-machine env -u)
