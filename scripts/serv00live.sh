#!/bin/bash

# 定义服务器和脚本信息
declare -A SERVERS=(
    ["server1"]="open02@s4.serv00.com"
    ["server2"]="open01@s4.serv00.com"
    ["server3"]="serv0001@s4.serv00.com"
    ["server4"]="serv0002@s4.serv00.com"
    ["server5"]="openmjj@s4.serv00.com"
    # 可以在这里添加更多服务器
    # ["server2"]="user@server.com"
)

SCRIPTS=(
        "pm2_resurrect_and_restart.sh"
    # 可以在这里添加更多脚本
)

# SSH 登录密码
PASSWORD="Tss@19740522"

# 遍历服务器并执行脚本
for server_key in "${!SERVERS[@]}"; do
    server="${SERVERS[$server_key]}"
    echo "Logging into $server"
    for script in "${SCRIPTS[@]}"; do
        echo "Setting execute permission for $script on $server"
        sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -tt $server "chmod +x ~/$script"
        echo "Executing $script on $server"
        sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -tt $server "bash -c './$script'"
    done
done
