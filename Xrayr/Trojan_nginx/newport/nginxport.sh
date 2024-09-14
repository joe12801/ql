#!/bin/bash
source  /etc/nginx/new_port.sh
sed -i "s/listen\s*${current_port}\s*ssl;/listen ${new_port} ssl;/g" /etc/nginx/nginx.conf
