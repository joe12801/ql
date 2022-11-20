#!/bin/bash
yum install -y epel-release rpm
rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm 
yum repolist 
yum install -y ffmpeg
echo "Asia/Shanghai" > /etc/timezone
#echo "0 3 * * * /root/centos_ffmpeg.sh" >> /var/spool/cron/root
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
mkdir /root/downloads
sleep 2
chmod 755 /root/downloads -R
cd /root/downloads
rm -rf wechat*

wget http://jd29.994938.xyz/d/root/gd/wechat.srt
sleep 2

 wget http://jd29.994938.xyz/d/root/gd/wechat.mp4
sleep 3 
str=$"\n"
nohup ffmpeg -i wechat.mp4 -vf "subtitles=wechat.srt"  wechat2.mp4 >/dev/null 2>&1 &
sstr=$(echo -e $str)
echo $sstr 

