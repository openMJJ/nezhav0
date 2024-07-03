#!/bin/bash

# 定义服务器和脚本信息
declare -A SERVERS=(
    ["server1"]="open02@s4.serv00.com"
    ["server2"]="open01@s4.serv00.com"
    ["server3"]="serv0001@s4.serv00.com"
    ["server4"]="serv0002@s4.serv00.com"
    ["server5"]="openmjj@s4.serv00.com"
    ["server6"]="serv502@s6.serv00.com"
    ["server6"]="serv601@s6.serv00.com"
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

# 获取状态为 stopped 或 errored 的进程 ID 并写入临时文件
~/.npm-global/bin/pm2 jlist | jq -r '.[] | select(.pm2_env.status == "stopped" or .pm2_env.status == "errored") | .pm_id' > pm2_ids.txt

# 读取临时文件中的进程 ID 并重启这些进程
while read id; do
    echo "Restarting process with ID: $id"  # 调试输出
    ~/.npm-global/bin/pm2 restart $id
done < pm2_ids.txt

# 删除临时文件
rm pm2_ids.txt

EOF
)

# 遍历服务器并执行脚本
for server_key in "${!SERVERS[@]}"; do
    server="${SERVERS[$server_key]}"
    echo "Logging into $server"

    # 将 pm2_script 内容作为临时脚本传输到远程服务器并执行
    sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -tt "$server" <<SSH
cat > ~/pm2_temp_script.sh << 'EOF'
$PM2_SCRIPT
EOF
chmod +x ~/pm2_temp_script.sh
echo "Executing script on $server"
bash ~/pm2_temp_script.sh
if [ \$? -ne 0 ]; then
    echo "Script execution failed on $server"
else
    echo "Script executed successfully on $server"
fi
echo "Deleting temporary script on $server"
rm ~/pm2_temp_script.sh
exit
SSH

    # 检查执行结果
    if [ $? -ne 0 ]; then
        echo "SSH session to $server failed or script execution failed"
    else
        echo "SSH session to $server completed successfully"
    fi

done
