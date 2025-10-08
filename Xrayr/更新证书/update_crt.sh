#!/bin/bash
# 停止 Nginx
systemctl stop nginx
# 更新证书
bash ~/.acme.sh/acme.sh --cron -f
# 启动 Nginx
systemctl start nginx
# 等待 Nginx 完全启动
sleep 5
# 检查 Nginx 状态
if ! systemctl is-active --quiet nginx; then echo "Nginx failed to start, check configuration" exit 1
fi
