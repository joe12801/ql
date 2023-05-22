#!/bin/bash

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

