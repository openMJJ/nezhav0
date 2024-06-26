#!/bin/bash

# 定义服务器和脚本信息
declare -A SERVERS=(

    ["server2"]="openmjj@s4.serv00.com"


    # 可以在这里添加更多服务器
    # ["server2"]="user@server.com"
    #open02=sublinkx,openmjj=哪吒
)

SCRIPT="autoBackupV2.sh"

# SSH 登录密码
PASSWORD="Tss@19740522"

# 函数：在服务器上执行脚本
execute_script_on_server() {
    local server_key="$1"
    local server="$2"
    echo "Logging into $server_key ($server)"

    # 设置 execute permission
    echo "Setting execute permission for $SCRIPT on $server"
    sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -tt "$server" "chmod +x ~/$SCRIPT"

    # 执行脚本
    echo "Executing $SCRIPT on $server"
    sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -tt "$server" "bash -c './$SCRIPT'"

    if [ $? -ne 0 ]; then
        echo "Error executing $SCRIPT on $server_key ($server)."
        return 1
    fi

    echo "Execution on $server_key ($server) complete."
    return 0
}

# 遍历服务器并执行脚本
for server_key in "${!SERVERS[@]}"; do
    server="${SERVERS[$server_key]}"
    execute_script_on_server "$server_key" "$server" &
done

# 等待所有后台任务完成
wait

echo "All servers processed."
