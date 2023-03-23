#!/bin/bash

# 搜索 crontab 中要删除的行
line=$(crontab -l | grep "/etc/nginx/change.sh")

# 如果找到要删除的行，则将其从 crontab 中删除
if [ -n "$line" ]
then
    (crontab -l | grep -v "/etc/nginx/change.sh") | crontab -
    echo "已删除定时任务：$line"
else
    echo "没有找到要删除的定时任务。"
fi
