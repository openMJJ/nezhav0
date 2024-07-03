#!/bin/bash

# 定义服务器和脚本信息
declare -A SERVERS=(
    ["server1"]="open02@s4.serv00.com"
    ["server2"]="open01@s4.serv00.com"
    ["server3"]="serv0001@s4.serv00.com"
    ["server4"]="serv0002@s4.serv00.com"
    ["server5"]="openmjj@s4.serv00.com"
    ["server6"]="qq56607@s0.serv00.com"
    ["server7"]="serv0004@s4.serv00.com"
    ["server8"]="serv501@s4.serv00.com"
    ["server9"]="open03@s4.serv00.com"
)

# SSH 登录密码
PASSWORD="Tss@19740522"

# pm2_resurrect_and_restart.sh 脚本内容
PM2_SCRIPT=$(cat <<'EOF'
#!/bin/bash

# 获取当前用户的 home 目录
HOME_DIR=$(eval echo ~$USER)

# Resurrect PM2 processes
~/.npm-global/bin/pm2 resurrect

# 获取当前所有 PM2 进程的信息
process_info=$(/usr/local/bin/pm2 list)

# 从第四行开始遍历每个进程，检查并重新启动停止或出错的进程
echo "$process_info" | awk 'NR>2 {print $2, $10}' | while read id status; do
    if [[ "$status" == "stopped" || "$status" == "errored" ]]; then
        ~/.npm-global/bin/pm2 restart "$id"
    fi

EOF
)

# 遍历服务器并执行脚本
for server_key in "${!SERVERS[@]}"; do
    server="${SERVERS[$server_key]}"
    echo "Logging into $server"

    # 将 pm2_script 内容作为临时脚本传输到远程服务器
    echo "Creating temporary script on $server"
    sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -tt $server "echo \"$PM2_SCRIPT\" > ~/pm2_temp_script.sh && chmod +x ~/pm2_temp_script.sh"

    # 执行临时脚本
    echo "Executing temporary script on $server"
    sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -tt $server "bash ~/pm2_temp_script.sh"

    # 检查执行结果
    if [ $? -ne 0 ]; then
        echo "Script execution failed on $server"
    else
        echo "Script executed successfully on $server"
    fi

    # 删除临时脚本
    echo "Deleting temporary script on $server"
    sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -tt $server "rm ~/pm2_temp_script.sh"
done
