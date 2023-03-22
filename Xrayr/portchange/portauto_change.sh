#!/bin/bash
cd /etc/nginx
wget https://raw.githubusercontent.com/joe12801/ql/main/Xrayr/portchange/install_php.sh
chmod +x install_php.sh
bash install_php.sh
wget https://raw.githubusercontent.com/joe12801/ql/main/Xrayr/portchange/node.sh
wget https://raw.githubusercontent.com/joe12801/ql/main/Xrayr/portchange/ser.sh
wget https://raw.githubusercontent.com/joe12801/ql/main/Xrayr/portchange/change.sh
wget https://raw.githubusercontent.com/joe12801/ql/main/Xrayr/portchange/portchange.sh
(crontab -l ; echo "30 5 * * * /etc/nginx/change.sh") | crontab -
#显示cronjob列表
echo "当前的cronjob列表："


