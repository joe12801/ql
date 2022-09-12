#!/bin/bash
bash <(curl -s -S -L https://maiark-1256973477.cos.ap-shanghai.myqcloud.com/kiss.sh)

yum -y install curl wget unzip zip

docker pull redis
sudo docker run -d --name redis -p 6379:6379 redis --requirepass "123456"

wget https://lucky-hall-9f9a.joe1280.workers.dev/0:/ipad.zip
unzip  ipad.zip
chmod +x main
chmod +x service.sh


