#!/bin/bash
set -x  # 启用调试模式

# GitHub 用户名和个人访问令牌
username="openmjj"
token="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"

# 备份文件名及路径
backup_dir="/usr/home/openmjj/nezhapanel"
backup_file="/usr/home/openmjj/Auto_backup_nezha_$(date +%Y%m%d%H%M).tar.gz"

# 创建备份文件
tar -czf "${backup_file}" -C "${backup_dir}" .

# GitHub 仓库地址
repo_url="https://${username}:${token}@github.com/openMJJ/nezha.git"
branch="main"
repo_dir="/usr/home/openmjj/repo"

# 检查并删除现有的 repo 目录
if [ -d "${repo_dir}" ]; then
    rm -rf "${repo_dir}"
fi

# 克隆仓库
git clone "${repo_url}" "${repo_dir}"
cd "${repo_dir}" || exit 1

# 复制备份文件
cp "${backup_file}" .

# 删除超过7天的备份文件
find . -name "Auto_backup_nezha_*.tar.gz" -mtime +7 -exec rm {} \;

# 添加、提交和推送更改
git add .
git commit -m "Backup on $(date)"
git push origin "${branch}"

# 清理
cd ..
rm -rf "${repo_dir}"
rm "${backup_file}"
