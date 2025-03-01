
# 哪吒面板与 Agent 一键降级指南

## 1. 替换客户端脚本
使用以下命令替换旧版客户端脚本：

```bash
curl -L https://raw.githubusercontent.com/Kiritocyz/nezha/main/install.sh -o install.sh
chmod +x install.sh
./install.sh
```

---

## 2. 哪吒面板一键降级

### 默认版本：18.0

执行以下命令，默认降级至 18.0 版本：

```bash
bash <(curl -Ls https://raw.githubusercontent.com/eooce/scripts/master/nezha.sh)
```

### 指定版本降级

如果需要降级到特定版本（例如 17.5）：

```bash
VERSION=17.5 bash <(curl -Ls https://raw.githubusercontent.com/eooce/scripts/master/nezha.sh)
```

---

## 3. nezha-agent 一键降级

### 默认版本：15.15

执行以下命令，默认降级至 15.15 版本：

```bash
bash <(curl -Ls https://raw.githubusercontent.com/eooce/scripts/master/agent.sh)
```
wget  https://github.com/nezhahq/agent/releases/tag/v0.17.5
```

### 指定版本降级

如果需要降级到特定版本（例如 16.11）：

```bash
VERSION=16.11 bash <(curl -Ls https://raw.githubusercontent.com/eooce/scripts/master/agent.sh)
```



---

## 4. 降级后检查版本

降级完成后，使用以下命令确认版本信息：

```bash
nezha-agent --version
```

或查看面板界面的版本信息以确认是否成功降级。
```

将以上内容复制到 `README.md` 文件中即可，GitHub 上会正确渲染格式。如果需要调整样式或增加内容，随时告诉我！
