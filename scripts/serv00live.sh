#!/bin/bash

# 定义服务器和脚本信息
declare -A SERVERS=(
    ["server1"]="open02@s4.serv00.com"
    ["server2"]="open01@s4.serv00.com"
    ["server3"]="serv0001@s4.serv00.com"
    ["server4"]="serv0002@s4.serv00.com"
    ["server5"]="openmjj@s4.serv00.com"
    ["server6"]="qq56607@s0.serv00.com"
    # 可以在这里添加更多服务器
    # ["server2"]="user@server.com"
)

# SSH 登录密码
PASSWORD="Tss@19740522"

# pm2_resurrect_and_restart.sh 脚本内容
PM2_SCRIPT=$(cat <<'EOF'
#!/bin/bash

# 获取当前用户的 home 目录
HOME_DIR=$(eval echo ~$USER)

# 确定 pm2 的路径
PM2_BIN=$(which pm2)

if [ -z "$PM2_BIN" ]; then
    echo "pm2 not found"
    exit 1
fi

# Resurrect PM2 processes
$PM2_BIN resurrect

# Check for stopped or errored processes and restart them
$PM2_BIN list | grep -E 'stopped|errored' | awk '{print $2}' | while read id; do
    $PM2_BIN restart $id
done
EOF
)

# 遍历所有服务器，创建并执行脚本
for server in "${!SERVERS[@]}"; do
    echo "正在连接 ${server} (${SERVERS[$server]})..."
    
    sshpass -p "$PASSWORD" ssh "${SERVERS[$server]}" "echo '$PM2_SCRIPT' > ~/pm2_resurrect_and_restart.sh && chmod +x ~/pm2_resurrect_and_restart.sh && ~/pm2_resurrect_and_restart.sh"
    
    if [ $? -eq 0 ]; then
        echo "${server} 脚本执行成功"
    else
        echo "${server} 脚本执行失败"
    fi
done
