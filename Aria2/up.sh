#!/bin/bash
path=$3 
dir=$(basename $(dirname $path)) 
dir_root=$(dirname $path)
echo dir_root > 1.txt
#/usr/local/bin/ctmd5 "$path"
#path2=${path}1
# mv $path $path2 
#path=$path2 
year=`date +%Y` 
month=`date +%m` 
day=`date +%d` 
if [ $dir = "downloads" ];then
        dir=""        
fi
filepath="$year/$month/$day/$dir" 
/usr/local/BaiduPCS-Go-v3.8.7-linux-arm64/BaiduPCS-Go mkdir $filepath 
str=$"\n"
nohup /usr/local/BaiduPCS-Go-v3.8.7-linux-arm64/BaiduPCS-Go u "$path" /$filepath &
sleep 500
#nohup /usr/bin/rclone  move $path  aliyun:$filepath  >/dev/null 2>&1 &
#/root/.aria2c/upload.sh

if [ $dir != "downloads" ];then
      #rm -rf $dir_root 
	echo $dir
fi
rm -rf "$path"
sstr=$(echo -e $str)
echo $sstr 





