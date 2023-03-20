mkdir /usr/local/cert
cd /usr/local/cert
wget https://raw.githubusercontent.com/joe12801/ql/main/Xrayr/update_cert.sh
chmod +x update_cert.sh
bash update_cert.sh
(crontab -l ; echo "30 3 * * * /usr/local/cert/update_cert.sh") | crontab -
#显示cronjob列表
echo "当前的cronjob列表："
crontab -l
