#!/bin/bash
set -x  # 启用调试模式

# GitHub 用户名和个人访问令牌
username="openmjj"
token="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"

# 备份文件名及路径
backup_dir="/usr/home/serv0002/nezhapanel"
backup_file="/usr/home/serv0002/Auto_backup_nezha_$(date +%Y%m%d%H%M).tar.gz"

# 创建备份文件
tar -czf ${backup_file} -C ${backup_dir} .

# GitHub 仓库地址
repo_url="https://$username:$token@github.com/openMJJ/nezha.git"
branch="main"

# 克隆仓库
git clone ${repo_url} repo
cd repo || exit

# 复制备份文件
cp ${backup_file} .

# 删除超过7天的备份文件
find . -name "Auto_nezha_backup_*.tar.gz" -mtime +7 -exec rm {} \;

# 添加、提交和推送更改
git add .
git commit -m "Backup on $(date)"
git push origin ${branch}

# 清理
cd ..
rm -rf repo

# 删除本地备份文件
rm ${backup_file}
