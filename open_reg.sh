#!/bin/bash
apt update 
apt install lrzsz curl git wget sudo unzip zip    python3-venv python3-full -y

wget https://github.com/joe12801/ql/raw/refs/heads/main/openai_reg-main.zip


unzip openai_reg-main.zip


# 进入你的项目目录（openai_reg-main）
cd  openai_reg-main

# 创建虚拟环境（命名为venv，也可以自定义）
python3 -m venv venv

source venv/bin/activate

pip install curl_cffi

# 将标准输出写入reg.log，错误输出也重定向到该文件
nohup ./venv/bin/python openai_reg.py > reg.log 2>&1 &
