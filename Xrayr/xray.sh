#!/bin/bash
atp install wget curl -y
bash <(curl -Ls https://raw.githubusercontent.com/XrayR-project/XrayR-release/master/install.sh)
cd /etc/XrayR
rm -rf /etc/XrayR/config.yml
wget https://github.com/joe12801/ql/raw/main/Xrayr/config.yml
Xrayr restart