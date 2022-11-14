#!/bin/bash
apt update
apt install wget curl nginx -y

sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config

systemctl stop firewalld.service

 
 systemctl start nginx
 systemctl status nginx.service
 systemctl enable nginx.service
 bash <(curl -L -s https://gitlab.com/rwkgyg/acme-script/raw/main/acme.sh) 
 
 
bash <(curl -Ls https://raw.githubusercontent.com/XrayR-project/XrayR-release/master/install.sh)
cd /etc/XrayR
rm -rf /etc/XrayR/config.yml
wget https://github.com/joe12801/ql/raw/main/Xrayr/Trojan_nginx/config.yml
