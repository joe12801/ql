#!/bin/bash

INSTALL_DIR=./xiaogpt

if ! [ -x "$(command -v curl)" ]; then
  echo -e "${RED}错误：${PLAIN} 未检测到 curl，请先安装此程序。" 
fi

if ! [ -x "$(command -v docker)" ]; then
  echo -e "${YELLOW}警告：${PLAIN} 未检测到 Docker。" 
  while true; do
    read -p "是否自动为你安装？是则输入 Y 并回车，否则输入 N 并回车。 " yn
    case $yn in
        [Yy]* ) curl -fsSL https://get.docker.com -o get-docker.sh; sudo -E sh get-docker.sh; rm get-docker.sh; break;;
        [Nn]* ) exit 1;;
        * ) echo "请输入 y 或 n";;
    esac
  done
fi

if ! [ -x "$(command -v docker-compose)" ]; then
  echo -e "${YELLOW}警告：${PLAIN} 未检测到 Docker Compose。" 
  while true; do
    read -p "是否自动为你安装？是则输入 Y 并回车，否则输入 N 并回车。 " yn
    case $yn in
        [Yy]* ) sudo -E curl -L "${DOCKER_COMPOSE_URL}" -o /usr/local/bin/docker-compose; sudo -E chmod +x /usr/local/bin/docker-compose; break;;
        [Nn]* ) exit 1;;
        * ) echo "请输入 y 或 n";;
    esac
  done
fi

mkdir xiaogpt

cd xiaogpt

wget https://github.com/joe12801/ql/raw/main/xiaogpt/config.json

wget https://github.com/joe12801/ql/raw/main/xiaogpt/docker-compose.yaml

wget https://github.com/joe12801/ql/raw/main/xiaogpt/cookies.json

# 读取用户输入的 openai_key 值
read -p "请输入 openai_key 值: " openai_key

# 读取用户输入的小米账号 account 值
read -p "请输入小米账号 account 值: " account

# 读取用户输入的小米的密码 password 值
read -p "请输入小米的密码 password 值: " password

# 读取用户输入的 小爱音箱的型号hardware 值
read -p "请输入小爱音箱的型号 hardware 值: " hardware

# 将用户输入的值赋给相应的变量
openai_key="$openai_key"
account="$account"
password="$password"
hardware="$hardware"

# 替换 config.json 中的对应值
sed -i "s/\"openai_key\": \"sk\"/\"openai_key\": \"$openai_key\"/g" config.json
sed -i "s/\"account\": \"13800138000\"/\"account\": \"$account\"/g" config.json
sed -i "s/\"password\": \"abcd1234\"/\"password\": \"$password\"/g" config.json
sed -i "s/\"hardware\": \"LX06\"/\"hardware\": \"$hardware\"/g" config.json


docker-compose up -d
