#!/bin/bash
apt update
apt install wget curl  -y

sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config

 bash <(curl -L -s https://gitlab.com/rwkgyg/acme-script/raw/main/acme.sh) 
 
 
 
bash <(curl -Ls https://raw.githubusercontent.com/XrayR-project/XrayR-release/master/install.sh)
cd /etc/XrayR
rm -rf /etc/XrayR/config.yml
wget https://raw.githubusercontent.com/joe12801/ql/main/Xrayr/config.yml

systemctl stop firewalld.service
systemctl start nginx
systemctl enable nginx.service
