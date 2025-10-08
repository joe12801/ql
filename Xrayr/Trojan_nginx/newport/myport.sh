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
# 删除旧任务并添加新任务
crontab -l | grep -v "acme.sh" | crontab - && echo "删除完成，当前任务列表：" && crontab -l
(crontab -l | grep -v "ckport.sh"; echo "0 0 * * 1 /etc/nginx/ckport.sh") | crontab -
#(crontab -l ; echo "* */6 * * * /etc/nginx/ckport.sh") | crontab -
#显示cronjob列表
echo "当前的cronjob列表："
crontab -l

