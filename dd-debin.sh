#!/bin/bash
apt-get update

apt-get install -y xz-utils openssl gawk file

apt-get install wget

bash <(wget --no-check-certificate -qO- 'https://moeclub.org/attachment/LinuxShell/InstallNET.sh') -d 10 -v 64 -a -firmware -p 12345