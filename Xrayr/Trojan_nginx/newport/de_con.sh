#!/bin/bash

# 搜索 crontab 中要删除的行
line=$(crontab -l | grep "/etc/nginx/ckport.sh")

# 如果找到要删除的行，则将其从 crontab 中删除
if [ -n "$line" ]
then
    (crontab -l | grep -v "/etc/nginx/ckport.sh") | crontab -
    echo "已删除定时任务：$line"
else
    echo "没有找到要删除的定时任务。"
fi
Ask
/etc/nginx/ckport.sh
(crontab -l ; echo "* */6 * * * /etc/nginx/ckport.sh") | crontab -
#显示cronjob列表
echo "当前的cronjob列表："
crontab -l
