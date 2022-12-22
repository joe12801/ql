#!/bin/bash
cd /etc/nginx
rm -rf nginx.conf 
wget https://github.com/joe12801/ql/raw/main/Xrayr/Trojan_nginx/nginx2.conf
mv nginx2.conf nginx.conf
systemctl restart nginx
