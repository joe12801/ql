#!/bin/bash
apt update -y
apt install php php-mysqli php-mysql -y
apt remove apache2 -y
