#!/bin/bash

# 获取用户输入的端口号
read -p "请输入新的端口号: " port

# 使用sed命令替换端口号
sudo sed -i "s/listen\s\+[0-9]\+\s*ssl;/listen $port ssl;/" /etc/nginx/nginx.conf

# 重启Nginx服务
sudo systemctl restart nginx