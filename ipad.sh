#!/bin/bash


yum -y install curl wget unzip zip

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
docker pull redis
sudo docker run -d --name redis -p 6379:6379 redis --requirepass "123456"

wget https://lucky-hall-9f9a.joe1280.workers.dev/0:/ipad.zip
unzip  ipad.zip
chmod +x main
chmod +x service.sh

