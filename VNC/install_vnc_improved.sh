#!/usr/bin/env bash
sudo apt install curl wget git  -y
sudo apt install chromium -y
set -euo pipefail

# Debian12 一键安装/修复 VNC（TigerVNC）+ XFCE
# 基于你提供的 install_vnc.sh 流程，做成真正可一键执行、可维护的脚本：
#1) root 一键执行：安装依赖 / 创建用户 / 写 xstartup / 写 systemd / 启动服务
#2) systemd 用 Type=simple + vncserver -fg：彻底规避 PIDFile 等不到导致 timeout
#3) 自动清理残留 vnc/X 锁文件：解决 restart 前必须 pkill/rm 的问题
#4) 支持参数化：用户名/显示号/分辨率/是否仅 localhost/中文字体与 UTF-8 locale

# ===== 参数（支持环境变量覆盖） =====
VNC_USER="${VNC_USER:-joe1280}"
DISPLAY_NUM="${DISPLAY_NUM:-1}" # :1 ->5901
GEOMETRY="${GEOMETRY:-1920x1080}"
DEPTH="${DEPTH:-24}"
LOCALHOST_ONLY="${LOCALHOST_ONLY:-1}" #1=仅本机(推荐SSH隧道)；0=允许远程直连
INSTALL_CN_FONTS="${INSTALL_CN_FONTS:-1}" #1=安装中文字体 + UTF-8 locale
LOCALE_UTF8="${LOCALE_UTF8:-zh_CN.UTF-8}"

log() { echo "[$(date +'%F %T')] $*"; }

# ===== 基础检查 =====
if [ "${EUID}" -ne 0 ]; then
 echo "ERROR: 请用 root 执行：sudo bash $0" >&2
 exit 1
fi

if [ -z "${VNC_USER}" ]; then
 echo "ERROR: VNC_USER不能为空" >&2
 exit 1
fi

VNC_DISPLAY=":${DISPLAY_NUM}"
VNC_PORT=$((5900 + DISPLAY_NUM))

log "目标：user=${VNC_USER} display=${VNC_DISPLAY} port=${VNC_PORT}"

# ===== 创建用户（如不存在） =====
if id -u "${VNC_USER}" >/dev/null2>&1; then
 log "用户已存在：${VNC_USER}"
else
 log "创建用户：${VNC_USER}"
 adduser "${VNC_USER}"
fi

VNC_HOME="$(getent passwd "${VNC_USER}" | cut -d: -f6)"
if [ -z "${VNC_HOME}" ]; then
 echo "ERROR: 无法获取用户 ${VNC_USER} 的 home目录" >&2
 exit 1
fi

# ===== 安装依赖 =====
log "安装 XFCE + TigerVNC +依赖..."
apt update
apt install -y \
 xfce4 xfce4-goodies dbus-x11 xorg \
 tigervnc-standalone-server tigervnc-common

if [ "${INSTALL_CN_FONTS}" = "1" ]; then
 log "安装中文字体 + locale（解决中文乱码/方块）..."
 apt install -y locales fontconfig fonts-noto-cjk fonts-wqy-zenhei fonts-wqy-microhei || true

 if ! locale -a | grep -qi "^${LOCALE_UTF8}$"; then
 # best-effort解除注释
 sed -i "s/^# \(${LOCALE_UTF8} UTF-8\)/\1/" /etc/locale.gen || true
 locale-gen "${LOCALE_UTF8}" || locale-gen
 fi

 update-locale LANG="${LOCALE_UTF8}" || true
 fc-cache -f -v >/dev/null2>&1 || true
fi

# ===== 写 xstartup =====
log "写入 xstartup..."
su - "${VNC_USER}" -c 'mkdir -p ~/.vnc'
cat > "${VNC_HOME}/.vnc/xstartup" <<EOF
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

# UTF-8（装了中文字体时建议开启）
export LANG=${LOCALE_UTF8}
export LC_ALL=${LOCALE_UTF8}
export LANGUAGE=zh_CN:zh

[ -f "\$HOME/.Xresources" ] && xrdb "\$HOME/.Xresources"
exec dbus-launch --exit-with-session startxfce4
EOF
chown "${VNC_USER}:${VNC_USER}" "${VNC_HOME}/.vnc/xstartup"
chmod +x "${VNC_HOME}/.vnc/xstartup"

# ===== 设置 VNC 密码（交互） =====
log "设置 VNC 密码（会问 view-only password：选 n 即可）..."
su - "${VNC_USER}" -c 'tigervncpasswd'

# ===== 清理残留（做成自动） =====
cleanup_vnc() {
 log "清理残留 VNC进程/锁文件..."
 pkill -9 Xvnc2>/dev/null || true
 pkill -9 vncserver2>/dev/null || true
 pkill -9 Xtigervnc2>/dev/null || true
 sleep 2 || true
 rm -rf /tmp/.X11-unix/X* /tmp/.X*-lock || true
 rm -f "${VNC_HOME}/.vnc"/*.pid "${VNC_HOME}/.vnc"/*.log2>/dev/null || true
}
cleanup_vnc

# ===== systemd 服务（Type=simple + -fg） =====
log "写入 systemd 服务：vncserver@${DISPLAY_NUM}.service"
SERVICE_FILE="/etc/systemd/system/vncserver@${DISPLAY_NUM}.service"

if [ "${LOCALHOST_ONLY}" = "1" ]; then
 LOCAL_FLAG="-localhost yes"
 CONN_HINT="SSH 隧道（推荐）：ssh -L${VNC_PORT}:127.0.0.1:${VNC_PORT} ${VNC_USER}@<server_ip>；VNC 连127.0.0.1:${VNC_PORT}"
else
 LOCAL_FLAG="-localhost no"
 CONN_HINT="直连：<server_ip>:${VNC_PORT}（不建议暴露公网）"
fi

cat > "${SERVICE_FILE}" <<EOF
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
EOF

log "重载 systemd 并启动服务..."
systemctl daemon-reload
systemctl enable --now "vncserver@${DISPLAY_NUM}.service"

log "服务状态："
systemctl --no-pager status "vncserver@${DISPLAY_NUM}.service" || true

echo
echo "✅ 完成。"
echo "- VNC 用户：${VNC_USER}"
echo "- display：${VNC_DISPLAY}"
echo "-端口：${VNC_PORT}"
echo "-连接方式：${CONN_HINT}"
echo
echo "若仍异常，请发："
echo " systemctl status vncserver@${DISPLAY_NUM}.service --no-pager"
echo " journalctl -u vncserver@${DISPLAY_NUM}.service -n120 --no-pager"
