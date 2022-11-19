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
rm -rf wa*
sleep 2

 wget http://jd29.994938.xyz/d/root/gd/wa.mkv
sleep 3
 wget http://jd29.994938.xyz/d/root/gd/English.srt
sleep 2
str=$"\n"
nohup ffmpeg -i wa.mkv -vf "subtitles=English.srt"  wa.mp4 >/dev/null 2>&1 &
sstr=$(echo -e $str)
echo $sstr 

