#!/bin/bash


yum -y install curl wget unzip zip

wget https://github.com/joe12801/ql/raw/main/kiss.sh && bash kiss.sh
docker pull redis
docker run -d --name redis -p 6379:6379 redis --requirepass "123456"

wget https://lucky-hall-9f9a.joe1280.workers.dev/0:/ipad.zip
unzip  ipad.zip
 cd ipad/
chmod +x main
chmod +x service.sh
firewall-cmd --zone=public --add-port=18080/tcp --permanent
firewall-cmd --reload
./service.sh


