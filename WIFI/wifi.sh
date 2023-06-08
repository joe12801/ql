#!/bin/bash

echo "1" | sudo -S apt update
sudo apt-get install  git wget pulseaudio sox alsa-utils unzip zip python3 python3-pip portaudio19-dev -y 

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
 
echo "host" | sudo -S tee /sys/kernel/debug/usb/ci_hdrc.0/role <<< "1" 

sudo sed -i '/gc -e/ a\
echo host > /sys/kernel/debug/usb/ci_hdrc.0/role' /usr/sbin/mobian-usb-gadget 


sox -d -d &

# 获取sox命令的PID
sox_pid=$!

# 等待5秒
sleep 5

# 终止sox进程
kill "$sox_pid" 
 
mkdir chatgpt

cd   chatgpt
 
git clone https://github.com/joe12801/wifi_chatgpt.git
cd wifi_chatgpt

pip install lz4-4.3.3.dev2+g58df083-cp39-cp39-linux_aarch64.whl

pip install -r requirements.txt

touch start.sh

echo '#!/bin/bash
sleep 5
cd /home/user/wifi_chatgpt/chatgpt
su -c "python3 main.py" user
exit 0' > start.sh

chmod +x start.sh

sudo sh -c 'echo "/bin/bash /root/chatgpt/wifi_chatgpt/start.sh" >> /etc/rc.local'

sudo reboot








