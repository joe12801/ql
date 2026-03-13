#/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install xfce4 xfce4-goodies dbus-x11 xorg -y
sudo apt install tigervnc-standalone-server tigervnc-common -y
su - joe1280
vncpasswd
vncserver -kill :*
nano ~/.vnc/xstartup
编辑启动脚本xstartup：
bash
运行
nano ~/.vnc/xstartup
清空原有内容，粘贴以下适配 Xfce4 的配置：
bash
运行
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4

sudo nano /etc/systemd/system/vncserver@.service


vncserver@.service的内容如下

[Unit]
Description=Remote VNC Desktop for joe1280
After=network.target syslog.target

[Service]
User=joe1280
Group=joe1280
Type=forking
WorkingDirectory=/home/joe1280

# 启动前清理残留
ExecStartPre=-/usr/bin/vncserver -kill :%i > /dev/null 2>&1
# 核心启动命令：强制允许所有IP连接，禁用localhost限制
ExecStart=/usr/bin/vncserver -interface 0.0.0.0 -localhost no -geometry 1920x1080 -depth 24 :%i
ExecStop=/usr/bin/vncserver -kill :%i

Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target

sudo systemctl daemon-reload

sudo systemctl enable --now vncserver@1.service

sudo systemctl status vncserver@1.service


在执行sudo systemctl restart vncserver@1.service 之前，先执行下面的代码，才能成功重启
# 3. 强制杀掉所有VNC相关进程（不管有没有）
sudo pkill -9 Xvnc
sudo pkill -9 vncserver
sudo pkill -9 Xtigervnc
# 4. 等待2秒，确保进程完全退出
sleep 2
# 5. 再次确认没有残留进程
ps aux | grep -i vnc
# 如果上面命令还有vnc进程，手动杀掉：sudo kill -9 <进程PID>
# 6. 清理所有锁文件、pid、日志
sudo rm -rf /tmp/.X11-unix/X*
sudo rm -rf /tmp/.X*-lock
sudo rm -rf /home/joe1280/.vnc/*.pid
sudo rm -rf /home/joe1280/.vnc/*.log

sudo systemctl restart vncserver@1.service
