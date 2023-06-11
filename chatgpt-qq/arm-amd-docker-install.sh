#!/bin/bash
apt install zip unzip -y

wget https://github.com/joe12801/ql/raw/main/chatgpt-qq/chatgpt-qq-arm-docker.zip
unzip chatgpt-qq-arm-docker.zip
cd chatgpt-qq 
docker-compose pull && docker-compose up -d
echo "自己动手修改配置文件，修改配置之后重启就可以"
rm -rf  /root/arm-amd-docker-install.sh
## https://chatgpt-qq.lss233.com/pei-zhi-wen-jian-jiao-cheng/jie-ru-ai-ping-tai/jie-ru-xun-fei-xing-huo-da-mo-xing

