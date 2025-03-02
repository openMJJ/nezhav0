#!/bin/bash

echo "========== Nezha 监控 Agent 安装/更新脚本 =========="

# 交互式输入服务器 IP、端口、密钥
read -p "请输入 Nezha 服务器 IP: " SERVER_IP
read -p "请输入 Nezha 服务器端口: " SERVER_PORT
read -p "请输入 Nezha 客户端密钥: " CLIENT_SECRET

# 获取当前脚本所在目录
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# 检查 nezha-agent 是否存在于当前目录
NEZHA_PATH="$SCRIPT_DIR/nezha-agent"
if [ ! -f "$NEZHA_PATH" ]; then
    echo "错误：未找到 nezha-agent 文件，请确保脚本目录下有 nezha-agent"
    exit 1
fi

# 赋予执行权限
chmod +x "$NEZHA_PATH"

# 停止并禁用旧的 nezha-agent 服务（如果已运行）
echo "🔄 停止旧的 Nezha Agent..."
systemctl stop nezha-agent 2>/dev/null
systemctl disable nezha-agent 2>/dev/null

# 创建 systemd 服务
SERVICE_FILE="/etc/systemd/system/nezha-agent.service"

cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Nezha Agent
After=network.target

[Service]
Type=simple
ExecStart=$NEZHA_PATH -s $SERVER_IP:$SERVER_PORT -p $CLIENT_SECRET --disable-auto-update
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# 重新加载 systemd
systemctl daemon-reload

# 启动 Nezha Agent 并设置开机自启
echo "🚀 启动新的 Nezha Agent..."
systemctl start nezha-agent
systemctl enable nezha-agent

# 检查运行状态
echo "========== Nezha Agent 运行状态 =========="
systemctl status nezha-agent --no-pager

echo "✅ Nezha Agent 已成功安装/更新，并设置为开机自启！"
