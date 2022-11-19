#!/bin/bash
yum install -y epel-release rpm
rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm
yum repolist
yum update
yum install -y ffmpeg
echo "0 3 * * * /root/ffmpeg.sh" >> /var/spool/cron/root
echo "Asia/Shanghai" > /etc/timezone
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
mkdir /root/downloads
sleep 2
chmod 755 /root/downloads -R
cd /root/downloads
rm -rf  Spirited-En.mp4
rm  -rf  English*
rm -rf  Spirited.2022*
sleep 2

 wget http://jd29.994938.xyz/d/root/gd/Spirited.2022.1080p.WEBRip.x264-RARBG.mp4 

 wget http://jd29.994938.xyz/d/root/gd/English.srt

str=$"\n"
nohup ffmpeg -i Spirited.2022.1080p.WEBRip.x264-RARBG.mp4 -vf "subtitles=English.srt" -threads 2 -c:v libx264 -crf 20 -c:a aac -b:a 2727k Spirited-En.mp4 >/dev/null 2>&1 &
sstr=$(echo -e $str)
echo $sstr 

