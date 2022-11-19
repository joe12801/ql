#!/bin/bash
apt update && apt upgrade -y
apt-get install cron
systemctl restart cron
chmod  0600 /var/spool/cron/crontabs/root -R
systemctl restart cron
echo "0 3 * * * /root/ffmpeg.sh" >> /var/spool/cron/crontabs/root
echo "Asia/Shanghai" > /etc/timezone
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
apt install ffmpeg -y
mkdir /root/downloads
sleep 2
chmod 755 /root/downloads -R
cd /root/downloads
rm -rf  Spirited-En.mp4
rm  -rf  English*
rm -rf  Spirited.2022*
sleep 2

 wget http://jd29.994938.xyz:5244/d/root/gd/Spirited.2022.1080p.WEBRip.x264-RARBG.mp4 

 wget http://jd29.994938.xyz:5244/d/root/gd/English.srt 

str=$"\n"
nohup ffmpeg -i Spirited.2022.1080p.WEBRip.x264-RARBG.mp4 -vf "subtitles=English.srt" -threads 2 -c:v libx264 -crf 20 -c:a aac -b:a 2727k Spirited-En.mp4 >/dev/null 2>&1 &
sstr=$(echo -e $str)
echo $sstr 

