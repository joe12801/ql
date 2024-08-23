#!/bin/bash
cd /etc/nginx
wget https://github.com/joe12801/ql/raw/main/Xrayr/cf/chatgpt.sh
chmod 777 chatgpt.sh
(crontab -l ; echo "0 */6 * * * /etc/nginx/chatgpt.sh") | crontab -
echo '更新成功'
