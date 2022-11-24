#!/bin/bash
docker  stop aria2-pro
docker rm aria2-pro
cd /root
rm -rf aria2-pro
apt install wget curl ca-certificates -y
wget -N git.io/aria2.sh && chmod +x aria2.sh && bash aria2.sh

cd /root/.aria2c
rm -rf aria2.conf core script.conf
wget https://github.com/joe12801/ql/raw/main/Aria2/aria2.conf
wget https://github.com/joe12801/ql/raw/main/Aria2/core
wget https://github.com/joe12801/ql/raw/main/Aria2/script.conf

chmod 755 script.conf core aria2.conf

systemctl restart aria2

bash <(curl -s -S -L https://rclone.org/install.sh)
rclone config

sleep 2
#mkdir /root/.config/rclone -R
cd /root/.config/rclone

wget https://github.com/joe12801/ql/raw/main/Aria2/rclone.conf

cd /root
systemctl restart aria2

