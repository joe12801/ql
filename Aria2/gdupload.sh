#!/bin/bash
apt install wget curl ca-certificates -y
wget -N git.io/aria2.sh && chmod +x aria2.sh && bash aria2.sh

cd /root/.aria2c
