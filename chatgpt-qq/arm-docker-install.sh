#!/bin/bash
apt install zip unzip 

wget https://github.com/joe12801/ql/raw/main/chatgpt-qq/chatgpt-qq-arm-docker.zip
zip chatgpt-qq-arm-docker.zip
cd chatgpt-qq 
docker-compose pull && docker-compose up -d
echo "自己动手修改配置文件"

