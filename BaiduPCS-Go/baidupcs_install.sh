#!/bin/bash

apt update 

apt install zip unzip


# 显示菜单选项
echo "请选择一个选项："
echo "1) amd"
echo "2) arm"

# 提示用户输入
read -p "请输入数字 (1 或 2): " choice

# 根据输入进行处理
case $choice in
    1)
        code="amd64"
        ;;
    2)
        code="arm64"
        ;;
    *)
        echo "无效的选择。请输入 1 或 2。"
        exit 1
        ;;
esac
rm -rf /usr/local/BaiduPCS-Go*
rm -rf /usr/bin/BaiduPCS-Go
wget -P /usr/local https://github.com/qjfoidnh/BaiduPCS-Go/releases/download/v3.9.6/BaiduPCS-Go-v3.9.6-linux-${code}.zip

unzip /usr/local/BaiduPCS-Go-v3.9.6-linux-${code}.zip -d /usr/local

ln -s /usr/local/BaiduPCS-Go-v3.9.6-linux-${code}/BaiduPCS-Go /usr/bin/BaiduPCS-Go



# 显示欢迎信息
echo "欢迎使用 BDUSS 和 STOKEN 输入脚本"

# 提示用户输入 bduss
read -p "请输入 bduss 的值: " bduss

# 检查 bduss 是否为空
if [ -z "$bduss" ]; then
    echo "错误: bduss 不能为空。"
    exit 1
fi

# 提示用户输入 stoken
read -p "请输入 stoken 的值: " stoken

# 检查 stoken 是否为空
if [ -z "$stoken" ]; then
    echo "错误: stoken 不能为空。"
    exit 1
fi

BaiduPCS-Go login -bduss=${bduss} -stoken=${stoken}

BaiduPCS-Go transfer https://pan.baidu.com/s/1FRI5gUKUlcJTcncSkI8HRA?pwd=9129 
