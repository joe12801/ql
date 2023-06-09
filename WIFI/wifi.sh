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

#######################替换KEY
#!/bin/bash

# 获取原始内容
original_content=$(<main.py)

# 提示用户输入新的API密钥
read -p "OpenAI API密钥(必填): " new_openai_api_key

# 提示用户输入新的PicoVoice API密钥
read -p "PicoVoice API密钥(必填): " new_picovoice_api_key

# 提示用户输入新的关键词路径
read -p "PicoVoice唤醒关键词路径(必填): " new_keyword_path

# 提示用户输入新的模型路径 https://github.com/Picovoice/porcupine/tree/master/lib/common
read -p "PicoVoice模型路径(选填): " new_model_path

# 提示用户输入新的百度APP ID
read -p "百度APP ID(选填): " new_baidu_app_id

# 提示用户输入新的百度API密钥
read -p "百度API密钥(选填): " new_baidu_api_key

# 提示用户输入新的Azure API密钥
read -p "Azure API密钥(选填): " new_azure_api_key

# 提示用户输入新的Azure区域
read -p "Azure区域(选填): " new_azure_region

# 提示用户输入新的SERPER API密钥
read -p "SERPER API密钥(选填): " new_serper_api_key

# 使用sed命令进行所有替换操作
new_content=$(echo "$original_content" |
    sed "s/openai_api_key = \".*\"/openai_api_key = \"$new_openai_api_key\"/" |
    sed "s/PICOVOICE_API_KEY = \".*\"/PICOVOICE_API_KEY = \"$new_picovoice_api_key\"/" |
    sed "s#keyword_path = '.*'#keyword_path = '$new_keyword_path'#" |
    sed "s#model_path = '.*'#model_path = '$new_model_path'#" |
    sed "s/Baidu_APP_ID = '.*'/Baidu_APP_ID = '$new_baidu_app_id'/" |
    sed "s/Baidu_API_KEY = '.*'/Baidu_API_KEY = '$new_baidu_api_key'/" |
    sed "s/AZURE_API_KEY = \".*\"/AZURE_API_KEY = \"$new_azure_api_key\"/" |
    sed "s/AZURE_REGION = \".*\"/AZURE_REGION = \"$new_azure_region\"/" |
    sed "s/os.environ\[\"SERPER_API_KEY\"\] = \".*\"/os.environ[\"SERPER_API_KEY\"] = \"$new_serper_api_key\"/")

# 将替换后的内容写回到main.py文件
echo "$new_content" > main.py
######################


pip install lz4-4.3.3.dev2+g58df083-cp39-cp39-linux_aarch64.whl

pip install -r requirements.txt

touch start.sh

echo '#!/bin/bash
sleep 5
cd /home/user/wifi_chatgpt/chatgpt
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


sudo reboot








