#!/bin/bash
mkdir /usr/local/cert
cd /usr/local/cert
wget https://raw.githubusercontent.com/joe12801/ql/refs/heads/main/Xrayr/%E6%9B%B4%E6%96%B0%E8%AF%81%E4%B9%A6/update_crt.sh
chmod +x update_crt.sh
bash update_crt.sh

(crontab -l ; echo "30 0 * * * /usr/local/cert/update_crt.sh") | crontab -

#显示cronjob列表
echo "当前的cronjob列表："
crontab -l
