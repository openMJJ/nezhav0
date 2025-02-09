+++

# Nezha v0 安装与配置指南

本文档为 Nezha v0 面板与 Agent 的安装及配置步骤，帮助用户轻松进行 Nezha v0 的安装和管理。

## 1. 面板部分

### ① 安装 v0 面板脚本

在服务器上执行以下命令进行 Nezha 面板的安装：

```bash
curl -L https://raw.githubusercontent.com/nezhahq/scripts/refs/heads/v0/install.sh -o nezha.sh && chmod +x nezha.sh && sudo ./nezha.sh
```

### ② 禁用面板更新

打开 `/opt/nezha/dashboard/docker-compose.yaml` 文件，将 Docker 镜像固定为 v0.20.13 版本：

```bash
services:
  dashboard:
    image: ghcr.io/naiba/nezha-dashboard:v0.20.13
    restart: always
```

感谢 [nodeseek.com](https://www.nodeseek.com/post-210009-1) 老哥的分享。

## 2. Agent 部分

### agent 安装脚本

1. 使用以下命令安装 Agent，记得将脚本中的 `main` 改为 `v0`。
2. 加入 `--disable-force-update` 禁用更新。
3. 如果不需要 Web SSH，加入 `--disable-command-execute` 禁止 Web SSH。

```bash
curl -L https://raw.githubusercontent.com/nezhahq/scripts/v0/install.sh -o nezha.sh && chmod +x nezha.sh && ./nezha.sh install_agent 域名 端口 密钥 --tls --disable-force-update --disable-command-execute
```

感谢 [nodeseek.com](https://www.nodeseek.com/post-209183-1#7) 老哥的帮助。

## 3. v0 文档

相关 v0 文档可以参考以下链接：

* 论坛分享的 v0 文档：[https://nezha-v0.mereith.dev/](https://nezha-v0.mereith.dev/)
* GitHub 仓库：[https://github.com/nezhahq/nezhahq.github.io/tree/v0](https://github.com/nezhahq/nezhahq.github.io/tree/v0)
* 互联网档案馆存档：[https://web.archive.org/web/20240929125721/https://nezha.wiki/guide/dashboard.html](https://web.archive.org/web/20240929125721/https://nezha.wiki/guide/dashboard.html)

感谢 [nodeseek.com](https://www.nodeseek.com/post-209098-1) 老哥的整理。
