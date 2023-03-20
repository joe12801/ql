#!/bin/bash
systemctl stop nginx
 "/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh"
 #sleep(15)
systemctl start nginx
