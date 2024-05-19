#!/bin/bash
wget https://github.com/joe12801/ql/raw/main/Xrayr/restart.sh
chmod +x restart.sh
(crontab -l ; echo "0 0 1 * * /root/restart.sh") | crontab -
