#!/bin/bash
apt update && apt upgrade -y
apt-get install cron
systemctl restart cron
chmod  0600 /var/spool/cron/crontabs/root -R
systemctl restart cron
#echo "0 3 * * * /root/ffmpeg.sh" >> /var/spool/cron/crontabs/root
echo "Asia/Shanghai" > /etc/timezone
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
apt install ffmpeg -y
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
nohup ffmpeg -i wechat.mp4 -vf "subtitles=wechat.srt" -threads 2 -c:v libx264 -crf 20 -c:a aac -b:a 2727k wechat2.mp4 >/dev/null 2>&1 &
sstr=$(echo -e $str)
echo $sstr 

