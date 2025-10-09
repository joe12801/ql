#!/bin/bash
apt update
apt install wget curl nginx-full -y

sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config

 bash <(curl -L -s https://gitlab.com/rwkgyg/acme-script/raw/main/acme.sh) 
 
 cd /etc/nginx
 rm -rf nginx.conf
 wget https://github.com/joe12801/ql/raw/main/Xrayr/Trojan_nginx/nginx.conf
 
 
 
bash <(curl -Ls https://raw.githubusercontent.com/XrayR-project/XrayR-release/master/install.sh)
cd /etc/XrayR
rm -rf /etc/XrayR/config.yml
wget https://github.com/joe12801/ql/raw/main/Xrayr/Trojan_nginx/config.yml

systemctl stop firewalld.service
systemctl start nginx
systemctl enable nginx.service

