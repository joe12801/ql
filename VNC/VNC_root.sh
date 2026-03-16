#!/usr/bin/env bash
set -euo pipefail

# 先安装基础依赖
apt install sudo -y
sudo apt install curl wget git -y
apt-get install -y xz-utils openssl gawk file jq

# Debian12 一键安装/修复 VNC（TigerVNC）+ XFCE
# 核心修改：VNC 用户改为 root，整合后续 Node.js 部署逻辑

# ===== 参数（已固定为 root） =====
VNC_USER="root"  # 强制使用 root 作为 VNC 用户
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

VNC_DISPLAY=":${DISPLAY_NUM}"
VNC_PORT=$((5900 + DISPLAY_NUM))

log "目标：user=${VNC_USER} display=${VNC_DISPLAY} port=${VNC_PORT}"

# ===== root 用户已存在，无需创建 =====
VNC_HOME="/root"
log "使用 root 用户，HOME 目录：${VNC_HOME}"

# ===== 安装依赖 =====
log "安装 XFCE + TigerVNC +依赖..."
apt update
apt install -y \
 xfce4 xfce4-goodies dbus-x11 xorg chromium \
 tigervnc-standalone-server tigervnc-common

if [ "${INSTALL_CN_FONTS}" = "1" ]; then
 log "安装中文字体 + locale（解决中文乱码/方块）..."
 apt install -y locales fontconfig fonts-noto-cjk fonts-wqy-zenhei fonts-wqy-microhei || true

 if ! locale -a | grep -qi "^${LOCALE_UTF8}$"; then
 # 解除注释并生成 locale
 sed -i "s/^# \(${LOCALE_UTF8} UTF-8\)/\1/" /etc/locale.gen || true
 locale-gen "${LOCALE_UTF8}" || locale-gen
 fi

 update-locale LANG="${LOCALE_UTF8}" || true
 fc-cache -f -v >/dev/null 2>&1 || true
fi

# ===== 写 xstartup（root 用户） =====
log "写入 xstartup..."
mkdir -p "${VNC_HOME}/.vnc"
cat > "${VNC_HOME}/.vnc/xstartup" <<EOF
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

# UTF-8 环境
export LANG=${LOCALE_UTF8}
export LC_ALL=${LOCALE_UTF8}
export LANGUAGE=zh_CN:zh

[ -f "\$HOME/.Xresources" ] && xrdb "\$HOME/.Xresources"
exec dbus-launch --exit-with-session startxfce4
EOF
chown root:root "${VNC_HOME}/.vnc/xstartup"
chmod +x "${VNC_HOME}/.vnc/xstartup"

# ===== 设置 VNC 密码（root 用户） =====
log "设置 VNC 密码（会问 view-only password：选 n 即可）..."
tigervncpasswd

# ===== 清理残留 =====
cleanup_vnc() {
 log "清理残留 VNC进程/锁文件..."
 pkill -9 Xvnc 2>/dev/null || true
 pkill -9 vncserver 2>/dev/null || true
 pkill -9 Xtigervnc 2>/dev/null || true
 sleep 2 || true
 rm -rf /tmp/.X11-unix/X* /tmp/.X*-lock || true
 rm -f "${VNC_HOME}/.vnc"/*.pid "${VNC_HOME}/.vnc"/*.log 2>/dev/null || true
}
cleanup_vnc

# ===== systemd 服务（适配 root 用户，修复 Type 问题） =====
log "写入 systemd 服务：vncserver@${DISPLAY_NUM}.service"
SERVICE_FILE="/etc/systemd/system/vncserver@${DISPLAY_NUM}.service"

if [ "${LOCALHOST_ONLY}" = "1" ]; then
 LOCAL_FLAG="-localhost yes"
 CONN_HINT="SSH 隧道（推荐）：ssh -L${VNC_PORT}:127.0.0.1:${VNC_PORT} root@<server_ip>；VNC 连127.0.0.1:${VNC_PORT}"
else
 LOCAL_FLAG="-localhost no"
 CONN_HINT="直连：<server_ip>:${VNC_PORT}（不建议暴露公网）"
fi

cat > "${SERVICE_FILE}" <<EOF
[Unit]
Description=Remote VNC Desktop for root
After=network.target syslog.target

[Service]
User=root
Group=root
Type=simple  # 用 simple + -fg 避免 PID 问题
WorkingDirectory=/root
ExecStartPre=-/usr/bin/vncserver -kill :%i > /dev/null 2>&1
# 启动命令（适配 root，参数化）
ExecStart=/usr/bin/vncserver -fg -interface 0.0.0.0 ${LOCAL_FLAG} -geometry ${GEOMETRY} -depth ${DEPTH} :%i
ExecStop=/usr/bin/vncserver -kill :%i

Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# 重载并启动服务
log "重载 systemd 并启动服务..."
systemctl daemon-reload
systemctl enable --now "vncserver@${DISPLAY_NUM}.service"

log "服务状态："
systemctl --no-pager status "vncserver@${DISPLAY_NUM}.service" || true

echo
echo "✅ VNC 安装完成。"
echo "- VNC 用户：${VNC_USER}"
echo "- display：${VNC_DISPLAY}"
echo "- 端口：${VNC_PORT}"
echo "- 连接方式：${CONN_HINT}"
echo

# ===== 安装 Node.js + nvm + pnpm + 部署项目（root 用户） =====
log "开始安装 nvm 和 Node.js..."

# 安装 nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

# 加载 nvm（无需重启 shell）
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# 安装 Node.js 24
nvm install 24
nvm use 24

# 验证 Node.js 版本
log "Node.js 版本：$(node -v)"

# 安装 pnpm
corepack enable pnpm
log "pnpm 版本：$(pnpm -v)"

# 克隆项目并部署
log "克隆项目并安装依赖..."
git clone https://github.com/linuxhsj/openclaw-zero-token.git || log "项目已存在，跳过克隆"
cd openclaw-zero-token || exit 1

pnpm install
pnpm build
pnpm ui:build

log "启动项目..."
bash start.sh

echo
echo "✅ 所有步骤执行完成！"
echo "- VNC 服务已启动（root 用户）"
echo "- Node.js + pnpm 已安装"
echo "- 项目已部署并启动"
