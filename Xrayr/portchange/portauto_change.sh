#!/bin/bash
cd /etc/nginx
rm -rf node.sh* ser.sh* change.sh* portchage.sh* port.php* del_con.sh* del_con.sh* install_php.sh*
wget https://raw.githubusercontent.com/joe12801/ql/main/Xrayr/portchange/install_php.sh
chmod +x install_php.sh
bash install_php.sh
wget https://raw.githubusercontent.com/joe12801/ql/main/Xrayr/portchange/port.php
wget https://raw.githubusercontent.com/joe12801/ql/main/Xrayr/portchange/node.sh
wget https://raw.githubusercontent.com/joe12801/ql/main/Xrayr/portchange/ser.sh
wget https://raw.githubusercontent.com/joe12801/ql/main/Xrayr/portchange/change.sh
wget https://raw.githubusercontent.com/joe12801/ql/main/Xrayr/portchange/portchage.sh
wget https://github.com/joe12801/ql/raw/main/Xrayr/portchange/del_con.sh

chmod +x node.sh ser.sh change.sh portchage.sh port.php del_con.sh
./del_con.sh
/etc/nginx/change.sh
(crontab -l ; echo "0,5 * * * * /etc/nginx/change.sh") | crontab -
#显示cronjob列表
echo "当前的cronjob列表："
crontab -l


