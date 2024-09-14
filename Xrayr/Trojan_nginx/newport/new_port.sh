#!/bin/bash
current_port=$(grep -Eo "listen\s+[0-9]+(\s|$)" /etc/nginx/nginx.conf | awk '{print $2}')

new_port=$(($current_port + 1))
echo $new_port
