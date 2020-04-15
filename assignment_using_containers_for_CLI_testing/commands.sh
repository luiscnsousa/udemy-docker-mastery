docker container run --rm -it --name ubuntu ubuntu:14.04 bash
apt-get update && apt-get install -y curl
curl --version

(cmd+T in iTerm to open new tab)
docker container run -it --rm --name centos centos:7 bash
yum install curl
curl --version