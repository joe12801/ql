#!/bin/bash

sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config

systemctl stop firewalld.service

 apt update
 apt install nginx
 systemctl start nginx
 systemctl status nginx.service
 systemctl enable nginx.service
 bash <(curl -L -s https://gitlab.com/rwkgyg/acme-script/raw/main/acme.sh) 
