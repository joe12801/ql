#!/bin/bash

PATH_TO_PYTHON_FILE="/home/user/wifi/main.py"
PORT_TO_CHECK=8080

CHECK_INTERVAL=60  # 延时检查的时间间隔，单位为秒
DELAY=3  # 命令之间的延时，单位为秒

connected=false

is_wifi_connected() {
    # 获取所有活动连接的列表
    connection_list=$(nmcli connection show)
  
    # 按行遍历连接列表
    while IFS= read -r line; do
        # 解析连接行的字段
        connection_name=$(echo "$line" | awk '{print $1}')
        type=$(echo "$line" | awk '{print $3}')
        state=$(echo "$line" | awk '{print $NF}')
      
        # 排除名称为"wifi"且类型为"wifi"的连接
        if [[ "$connection_name" != "wifi" ]] && [[ "$type" == "wifi" ]]; then
            # 检查连接的状态是否为"connected"
            if [[ "$state" == "wlan0" ]]; then
                connected=true
                break
            fi
        fi
    done <<< "$connection_list"
    
    if [[ "$connected" == true ]]; then
        echo "Wi-Fi is connected."
    else
        echo "Wi-Fi is not connected."
    fi
}

while true; do
    is_wifi_connected
    if [[ "$connected" == false ]]; then
        port_in_use=$(lsof -i :$PORT_TO_CHECK)
        if [[ -n "$port_in_use" ]]; then
            echo "Port $PORT_TO_CHECK is already in use. Terminating the process..."
            pid=$(echo "$port_in_use" | awk 'NR==2{print $2}')
            kill -9 $pid
            echo "Process with PID $pid has been terminated."
        else
            echo "Port $PORT_TO_CHECK is available."
        fi
        
        echo "Connecting to Wi-Fi hotspot..."
        nmcli d wifi hotspot ifname wlan0 ssid 4G-WIFI password 12345678
        sleep $DELAY
        python3 "${PATH_TO_PYTHON_FILE}"
    else
        echo "No further action needed."
    fi
    sleep $CHECK_INTERVAL  # 检查间隔
done