#!/bin/bash
set -euo pipefail

# 默认配置（可通过环境变量覆盖）
USER_TO_SETUP="${USER_TO_SETUP:-joe1280}"
DISPLAY_NUM="${DISPLAY_NUM:-1}"
GEOMETRY="${GEOMETRY:-1920x1080}"
DEPTH="${DEPTH:-24}"
VNC_PASSWORD="${VNC_PASSWORD:-}"

if [ "$EUID" -ne 0 ]; then
  echo "请以 root/sudo 运行此脚本：sudo bash install_vnc.sh"
  exit 1
fi

echo "设置 VNC: user=${USER_TO_SETUP}, display=${DISPLAY_NUM}, geometry=${GEOMETRY}, depth=${DEPTH}"

# 1) 安装必要包
apt update
apt upgrade -y
apt install -y xfce4 xfce4-goodies dbus-x11 xorg tigervnc-standalone-server tigervnc-common expect

# 2) 确保用户存在
if ! id -u "${USER_TO_SETUP}" >/dev/null 2>&1; then
  echo "用户 ${USER_TO_SETUP} 不存在，正在创建..."
  useradd -m -s /bin/bash "${USER_TO_SETUP}"
fi

# 3) 准备 .vnc 目录
VNC_HOME="/home/${USER_TO_SETUP}"
VNC_DIR="${VNC_HOME}/.vnc"
mkdir -p "${VNC_DIR}"
chown "${USER_TO_SETUP}:${USER_TO_SETUP}" "${VNC_DIR}"
chmod 700 "${VNC_DIR}"

# 4) 设置 VNC 密码（支持非交互环境变量 VNC_PASSWORD）
if [ -z "${VNC_PASSWORD}" ]; then
  echo "请为 VNC 用户 ${USER_TO_SETUP} 输入密码（交互式）:"
  runuser -l "${USER_TO_SETUP}" -c "vncpasswd"
else
  echo "使用 VNC_PASSWORD 环境变量设置 VNC 密码（非交互）"
  /usr/bin/expect <<EOF
spawn runuser -l ${USER_TO_SETUP} -c "vncpasswd"
expect "Password:"
send "${VNC_PASSWORD}\r"
expect "Verify:"
send "${VNC_PASSWORD}\r"
expect {
  "Would you like to enter a view-only password (y/n)?" { send "n\r"; exp_continue }
  eof
}
EOF
  chmod 600 "${VNC_DIR}/passwd"
  chown "${USER_TO_SETUP}:${USER_TO_SETUP}" "${VNC_DIR}/passwd"
fi

# 5) 创建 xstartup（覆盖旧文件，适配 Xfce4）
XSTARTUP_PATH="${VNC_DIR}/xstartup"
cat > "${XSTARTUP_PATH}" <<'XSU'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4
XSU

chown "${USER_TO_SETUP}:${USER_TO_SETUP}" "${XSTARTUP_PATH}"
chmod 755 "${XSTARTUP_PATH}"

# 6) 创建 systemd 模板单元 vncserver@.service
SERVICE_PATH="/etc/systemd/system/vncserver@.service"
cat > "${SERVICE_PATH}" <<SERVICE
[Unit]
Description=Remote VNC Desktop for %i (user: ${USER_TO_SETUP})
After=network.target syslog.target

[Service]
Type=forking
User=${USER_TO_SETUP}
Group=${USER_TO_SETUP}
WorkingDirectory=/home/${USER_TO_SETUP}

# 启动前清理残留 (忽略错误)
ExecStartPre=-/usr/bin/vncserver -kill :%i > /dev/null 2>&1

# 强制允许所有 IP 连接，禁用 localhost 限制
ExecStart=/usr/bin/vncserver -interface 0.0.0.0 -localhost no -geometry ${GEOMETRY} -depth ${DEPTH} :%i
ExecStop=/usr/bin/vncserver -kill :%i

Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
SERVICE

chmod 644 "${SERVICE_PATH}"

# 7) 重新加载 systemd 并启用服务
systemctl daemon-reload
systemctl enable --now "vncserver@${DISPLAY_NUM}.service" || true

# 8) 清理潜在残留进程及锁文件/日志
echo "清理潜在的残留 VNC 进程和锁/日志..."
pkill -9 Xvnc || true
pkill -9 vncserver || true
pkill -9 Xtigervnc || true
sleep 2
ps aux | grep -i vnc | grep -v grep || true

rm -rf /tmp/.X11-unix/X* /tmp/.X*-lock || true
rm -f "${VNC_DIR}"/*.pid "${VNC_DIR}"/*.log || true

# 9) 重启服务并显示状态
systemctl restart "vncserver@${DISPLAY_NUM}.service" || true

echo "VNC 服务已尝试启动。查看状态："
systemctl status "vncserver@${DISPLAY_NUM}.service" --no-pager || true

echo "VNC 安装与配置完成。要使用非交互密码，请在运行脚本前导出 VNC_PASSWORD。"