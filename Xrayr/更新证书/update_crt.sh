#!/bin/bash
systemctl stop nginx

~/.acme.sh/acme.sh --cron -f

systemctl restart nginx
