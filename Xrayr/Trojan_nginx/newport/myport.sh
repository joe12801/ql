#!/bin/bash
cd /etc/nginx
rm -rf node.sh* ser.sh* nginxport.sh*  new_port.sh*  check_port.sh* ckport.sh*
wget https://github.com/joe12801/ql/raw/main/Xrayr/Trojan_nginx/newport/ser.sh
wget https://github.com/joe12801/ql/raw/main/Xrayr/Trojan_nginx/newport/node.sh
wget https://github.com/joe12801/ql/raw/main/Xrayr/Trojan_nginx/newport/nginxport.sh
wget https://github.com/joe12801/ql/raw/main/Xrayr/Trojan_nginx/newport/new_port.sh
wget https://github.com/joe12801/ql/raw/main/Xrayr/Trojan_nginx/newport/check_port.sh
wget https://github.com/joe12801/ql/raw/main/Xrayr/Trojan_nginx/newport/ckport.sh
wget https://github.com/joe12801/ql/raw/main/Xrayr/Trojan_nginx/newport/update.php
wget https://github.com/joe12801/ql/raw/main/Xrayr/Trojan_nginx/newport/install_php.sh
chmod +x install_php.sh
bash install_php.sh

chmod +x node.sh ser.sh nginxport.sh new_port.sh check_port.sh ckport.sh update.php

/etc/nginx/ckport.sh
(crontab -l ; echo "*/10 * * * * /etc/nginx/ckport.sh") | crontab -
#显示cronjob列表
echo "当前的cronjob列表："
crontab -l

