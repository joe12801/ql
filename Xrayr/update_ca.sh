#!/bin/bash
cd /root/.acme.sh
rm -rf acme.sh
wget https://github.com/joe12801/ql/raw/refs/heads/main/acme.sh
bash ~/.acme.sh/acme.sh --cron -f
/etc/nginx/ckport.sh
