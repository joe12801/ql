#!/bin/bash
# 提示用户输入新的 OpenAI API 密钥
read -p "OpenAI API密钥(必填): " new_openai_api_key

# 提示用户输入新的 PicoVoice API 密钥
read -p "PicoVoice API密钥(必填): " new_picovoice_api_key

# 提示用户输入新的关键词路径
read -p "PicoVoice唤醒关键词路径(必填): " new_keyword_path
echo "1" | sudo -S apt update
sudo apt-get install  git wget pulseaudio sox alsa-utils unzip zip python3 python3-pip portaudio19-dev -y 
sudo apt-get install python3-gst-1.0 gir1.2-gst-plugins-base-1.0 -y
sudo apt-get install python3-gi python3-gi-cairo gir1.2-gtk-3.0 -y
pip install paho-mqtt
pip install flask
pip install pydub 
sudo apt install ffmpeg -y
sudo apt install -y python3-dev libgirepository1.0-dev libcairo2-dev -y
echo "1" | sudo -S apt update
sudo apt install -y gstreamer1.0-tools gstreamer1.0-plugins-good gstreamer1.0-plugins-base gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad
pip install pygobject

echo "1" | sudo -S touch /etc/systemd/user/pulseaudio.service

service_file="/etc/systemd/user/pulseaudio.service"
content="[Unit]\nDescription=PulseAudio Daemon\n\n[Service]\nExecStart=/usr/bin/pulseaudio --daemonize=no\nRestart=on-failure\n\n[Install]\nWantedBy=default.target"

# 将内容写入服务文件
echo -e "$content" | sudo tee "$service_file" >/dev/null


# 更改文件权限
sudo chmod 644 "$service_file" <<< "1"

echo "PulseAudio service file created at $service_file"

systemctl --user enable pulseaudio.service
 
systemctl --user start pulseaudio.service
 
#echo "host" | sudo -S tee /sys/kernel/debug/usb/ci_hdrc.0/role <<< "1" 

sudo sed -i '/gc -e/ a\sleep 1\necho host > /sys/kernel/debug/usb/ci_hdrc.0/role' /usr/sbin/mobian-usb-gadget



#sox -d -d &

# 获取sox命令的PID
#sox_pid=$!

# 等待5秒
#sleep 5

# 终止sox进程
#kill "$sox_pid" 
 
mkdir chatgpt

cd   chatgpt
 
git clone https://github.com/joe12801/wifi_chatgpt.git
cd wifi_chatgpt

#######################替换KEY
# 获取原始内容
original_content=$(<main.py)



# 使用 awk 命令进行替换操作
new_content=$(echo "$original_content" |
    awk -v new_openai_api_key="$new_openai_api_key" \
        -v new_picovoice_api_key="$new_picovoice_api_key" \
        -v new_keyword_path="$new_keyword_path" \
        '{
            if ($0 ~ /^openai_api_key = /) {
                print "openai_api_key = \"" new_openai_api_key "\"";
            } else if ($0 ~ /^PICOVOICE_API_KEY = /) {
                print "PICOVOICE_API_KEY = \"" new_picovoice_api_key "\"";
            } else if ($0 ~ /^keyword_path = /) {
                print "keyword_path = \"" new_keyword_path "\"";
            } else {
                print $0;
            }
        }')

echo "$new_content" > main.py

######################


pip install lz4-4.3.3.dev2+g58df083-cp39-cp39-linux_aarch64.whl

pip install -r requirements.txt

touch start.sh

echo '#!/bin/bash
sleep 8
cd /home/user/chatgpt/wifi_chatgpt/
su -c "python3 main.py" user
exit 0' > start.sh

chmod +x start.sh

##################开机启动###

# 定义要插入的内容
insert_content="/bin/bash /home/user/chatgpt/wifi_chatgpt/start.sh"

# 创建一个临时文件用于存储修改后的内容
temp_file=$(mktemp)

# 将要插入的内容写入临时文件
echo "$insert_content" > "$temp_file"

# 读取 /etc/rc.local 文件内容，并将内容插入临时文件中
sed -e "/exit 0/{e cat $temp_file" -e "}" /etc/rc.local > "$temp_file.tmp"

# 将临时文件替换为原始文件
sudo mv "$temp_file.tmp" /etc/rc.local

# 授予正确的权限
sudo chmod +x /etc/rc.local
sudo rm -rf /root/wifi.sh
echo "重启..."
sudo reboot







