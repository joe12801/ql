#!/bin/bash

while true; do
    clear
    echo "==== ChatGPT自动接入-微信/Telegram电报群/Web网页版 三合一懒人版1.5 2023-2-26 ===="
    echo "希望多多支持 如果有疑问请访问下方网址咨询"
    echo "小风博客 官网:blog.evv1.com"
    echo ""
    echo "--- 1.7版本更新内容---"
    echo "①. 更新支持多环境，支持系统Debian11.x、Centos8/9、Ubuntu20.x"
    echo "②. 修复微信常驻后台问题"
    echo "③. 加入结束微信和Telegram常驻后台"
    echo "④. 后台运行微信时，可自动显示二维码链接，无需再手动输入命令获取"
    echo "⑤. 加入卸载服务命令"
    echo "⑥  优化输入API KEY的体验，1.3版本之前的需要执行“2”步恢复出厂才可以体验"
    echo "⑦  加入检测你的服务器IP是否支持ChatGPT"
    echo "⑧  增加网页版ChatGPT，体验更好支持理解上下文"
    echo "⑨  优化Web版的响应速度"
    echo "⑩  Web端已经接入最新的ChatGPT3.5的官方模型，已经和官方原版一摸一样"
    echo ""
    echo ""
    echo "--- 必要环境 ---"
    echo "0. 检测服务器是否支持ChatGPT"
    echo "1. 配置环境"
    echo "2. 拉取ChatGPT服务(必要时此项可以重置服务)"
    echo ""
    echo ""
    echo "--- 微信端配置 ---"
    echo "3. 配置微信API"
    echo "4. 临时运行微信版ChatGPT"
    echo "5. 后台常驻运行微信版ChatGPT"
    echo "6. 结束后台常驻运行微信版ChatGPT"
    echo ""
    echo ""
    echo "--- Telegram端配置 ---"
    echo "7. 配置Telegram API"
    echo "8. 后台常驻运行Telegram版ChatGPT"
    echo "9. 结束后台运行Telegram版ChatGPT"
    echo ""
    echo ""
    echo "--- Web端配置（推荐已经接入官方原版ChatGPT3.5模型） ---"
    echo "10. 配置Web端 API"
    echo "11. 启动Web版ChatGPT后端"
    echo "12. 启动Web版ChatGPT前端"
    echo "13. 结束后台运行Web版ChatGPT"
    echo ""
    echo ""
    echo "--- 卸载服务端 ---"
    echo "14. 卸载服务"
    echo ""
    echo ""
    echo "q. 退出"
    echo ""
    echo ""
    read -p "请选择一个选项: " option
    case $option in
        0)
          echo "检测服务器是否支持ChatGPT"
          #!/bin/bash

          RED='\033[0;31m'
          PLAIN='\033[0m'
          GREEN='\033[0;32m'
          Yellow="\033[33m";
          log="unlock-chatgpt-test-result.log"

          clear;
          echo -e "${GREEN}** Chat GPT ip可用性检测${PLAIN} ${Yellow}${PLAIN}" && echo -e "Chat GPT ip可用性检测" > ${log};
          echo -e "${RED}** 提示 本工具测试结果仅供参考，请以实际使用为准${PLAIN}" && echo -e "提示 本工具测试结果仅供参考，请以实际使用为准" >> ${log};
          echo -e "** 系统时间: $(date)" && echo -e " ** 系统时间: $(date)" >> ${log};

          # Check if curl is installed
          if ! command -v curl &> /dev/null; then
            echo "curl is not installed. Installing curl..."
            if command -v yum &> /dev/null; then
              sudo yum install curl -y
            elif command -v apt-get &> /dev/null; then
              sudo apt-get install curl -y
            else
              echo "Your system package manager is not supported. Please install curl manually."
              exit 1
            fi
          fi

          # Check if grep is installed
          if ! command -v grep &> /dev/null; then
            echo "grep is not installed. Installing grep..."
            if command -v yum &> /dev/null; then
              sudo yum install grep -y
            elif command -v apt-get &> /dev/null; then
              sudo apt-get install grep -y
            else
              echo "Your system package manager is not supported. Please install grep manually."
              exit 1
            fi
          fi



          function UnlockChatGPTTest() {
              if [[ $(curl --max-time 10 -sS https://chat.openai.com/ -I | grep "text/plain") != "" ]]
              then
                  local ip="$(curl -s http://checkip.dyndns.org | awk '{print $6}' | cut -d'<' -f1)"
                  echo -e " 抱歉！本机IP：${ip} ${RED}目前不支持ChatGPT IP is BLOCKED${PLAIN}" | tee -a $log
                  return
              fi
              local countryCode="$(curl --max-time 10 -sS https://chat.openai.com/cdn-cgi/trace | grep "loc=" | awk -F= '{print $2}')";
              if [ $? -eq 1 ]; then
                  echo -e " ChatGPT: ${RED}网络连接失败 Network connection failed${PLAIN}" | tee -a $log
                  return
              fi
              if [ -n "$countryCode" ]; then
                  support_countryCodes=(T1 XX AL DZ AD AO AG AR AM AU AT AZ BS BD BB BE BZ BJ BT BA BW BR BG BF CV CA CL CO KM CR HR CY DK DJ DM DO EC SV EE FJ FI FR GA GM GE DE GH GR GD GT GN GW GY HT HN HU IS IN ID IQ IE IL IT JM JP JO KZ KE KI KW KG LV LB LS LR LI LT LU MG MW MY MV ML MT MH MR MU MX MC MN ME MA MZ MM NA NR NP NL NZ NI NE NG MK NO OM PK PW PA PG PE PH PL PT QA RO RW KN LC VC WS SM ST SN RS SC SL SG SK SI SB ZA ES LK SR SE CH TH TG TO TT TN TR TV UG AE US UY VU ZM BO BN CG CZ VA FM MD PS KR TW TZ TL GB)
                  if [[ "${support_countryCodes[@]}"  =~ "${countryCode}" ]];  then
                      local ip="$(curl -s http://checkip.dyndns.org | awk '{print $6}' | cut -d'<' -f1)"
                      echo -e " 恭喜！本机IP:${ip} ${GREEN}支持ChatGPT Yes (Region: ${countryCode})${PLAIN}" | tee -a $log
                      return
                  else
                      echo -e " ChatGPT: ${RED}No${PLAIN}" | tee -a $log
                      return
                  fi
              else
                  echo -e " ChatGPT: ${RED}Failed${PLAIN}" | tee -a $log
                  return
              fi

          }

          UnlockChatGPTTest
          # 在这里添加运行微信版ChatGPT的命令
          read -n 1 -s -r -p "按任意键继续..."
          ;;
        1)
            echo "配置环境..."
            #!/bin/bash

# Check if the system is Ubuntu
if [ -f /etc/lsb-release ]; then
  apt-get update
  apt-get install -y curl
  curl -fsSL https://get.docker.com | bash -s docker

# Check if the system is CentOS or Red Hat
elif [ -f /etc/redhat-release ]; then
  yum update
  yum install -y curl
  curl -fsSL https://get.docker.com | bash -s docker
  systemctl start docker

# Check if the system is Debian
elif [ -f /etc/debian_version ]; then
  apt-get update
  apt-get install -y curl
  curl -fsSL https://get.docker.com | bash -s docker

# If the system is not supported, display an error message
else
  echo "Unsupported system."
  exit 1
fi
            # 在这里添加配置环境的命令
            read -n 1 -s -r -p "配置成功，按任意键继续，进行第二步..."
            ;;
        2)
            echo "拉取服务..."
            docker stop wechatgpt
            docker rm wechatgpt
            docker rmi -f veelove/wetgchat:wetgchat
            docker rmi -f veelove/wetgchat:wetgchat1
            docker pull veelove/wetgchat:wetgchat3
            docker run -it --name=wechatgpt -d --restart always -p 1002:1002 -p 3002:3002 veelove/wetgchat:wetgchat3
            # 在这里添加拉取服务的命令
            read -n 1 -s -r -p "配置成功，按任意键继续，进行第三步..."
            ;;
        3)
            echo "配置微信API（可以二次修改）"
            read -p "请输入OpenAI的KEY后回车：" sk
            docker exec wechatgpt /bin/bash -c "cd chatgpt_wechat_robot && sed -i 's/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/$sk/g' config.json && jq '.api_key = \"$sk\"' config.json > tmp_config.json && mv tmp_config.json config.json"

           # 在这里添加配置微信API的命令
            read -n 1 -s -r -p "配置成功，按任意键继续，进行第四步..."
            ;;
        4)
            echo "临时运行微信版ChatGPT..."
            docker exec -it wechatgpt /bin/bash -c "cd chatgpt_wechat_robot && go run main.go"
            # 在这里添加运行微信版ChatGPT的命令
            read -n 1 -s -r -p "按任意键继续..."
            ;;
        5)
            echo "后台运行微信版ChatGPT"
            docker exec -it wechatgpt /bin/bash -c "screen -dmS $(hostname) bash -c 'cd chatgpt_wechat_robot; go run main.go'; screen -r $(hostname)"
            # 在这里添加运行微信版ChatGPT的命令
            read -n 1 -s -r -p "按任意键继续..."
            ;;
        6)
            echo "已经结束微信后台"
            docker exec -it wechatgpt /bin/bash -c "screen -ls | grep Attached | cut -d'.' -f1 | awk '{print $1}' | xargs -I{} screen -X -S {} quit"
            # 在这里添加运行微信版ChatGPT的命令
            read -n 1 -s -r -p "配置成功，按任意键继续..."
            ;;
        7)
            echo "配置Telegram API（注意：只能配置一次，不能二次修改）"
            # Get sk value from user input
            read -p "请输入OpenAI的KEY后回车：" sk

            # Get telegram bot token from user input
            read -p "请输入telegram的KEY后回车：" token

            # Copy .env file to a temporary location
            docker cp wechatgpt:/chatgpt-bot-telegram/.env /tmp/.env.temp

            # Replace sk value in the .env file
            sed -i "s/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/$sk/g" /tmp/.env.temp

            # Replace telegram bot token in the .env file
            sed -i "s/6205140247:AAHJUD3LujRp_0hKvPTSmG4E60AZBdsi0pk/$token/g" /tmp/.env.temp

            # Copy modified .env file back to the container
            docker cp /tmp/.env.temp wechatgpt:/chatgpt-bot-telegram/.env

            # Remove temporary .env file
            rm /tmp/.env.temp

            # 在这里添加运行微信版ChatGPT的命令
            read -n 1 -s -r -p "配置成功，按任意键继续，进行第八步..."
            ;;
        8)
            echo "后台常驻运行Telegram版ChatGPT"
            docker exec -it wechatgpt /bin/bash -c "cd chatgpt-bot-telegram && npm install && pm2 start index.js"
            # 在这里添加运行微信版ChatGPT的命令
            read -n 1 -s -r -p "按任意键继续..."
            ;;

        9)
            echo "后台常驻运行Telegram版ChatGPT"
            docker exec -it wechatgpt /bin/bash -c "pm2 list && pm2 stop 0"
            # 在这里添加运行微信版ChatGPT的命令
            read -n 1 -s -r -p "已经结束后台常驻运行Telegram版ChatGPT，按任意键继续..."
            ;;
        10)
            echo "配置Web API（注意：只能配置一次，不能二次修改）"
                # Get sk value from user input
            read -p "请输入OpenAI的KEY后回车：" sk
                # Copy .env file to a temporary location
            docker cp wechatgpt:/chatgpt-web/service/.env /tmp/.env.temp

                # Replace sk value in the .env file
            sed -i "s/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/$sk/g" /tmp/.env.temp

                # Replace telegram bot token in the .env file
            sed -i "s/6205140247:AAHJUD3LujRp_0hKvPTSmG4E60AZBdsi0pk/$token/g" /tmp/.env.temp

                # Copy modified .env file back to the container
            docker cp /tmp/.env.temp wechatgpt:/chatgpt-web/service/.env

                # Remove temporary .env file
            rm /tmp/.env.temp

                # 在这里添加运行微信版ChatGPT的命令
            read -n 1 -s -r -p "配置成功，按任意键继续，进行第十一步..."
            ;;
        11)
            echo "启动Web版后端ChatGPT"
            docker exec -it wechatgpt /bin/bash -c "cd /chatgpt-web/service && nohup sh -c 'export PATH=$PATH:/usr/local/bin && export NODE_ENV=production && pnpm start > log.out 2>&1 &'"
            # 在这里添加运行微信版ChatGPT的命令
            read -n 1 -s -r -p "已经运行成功Web版后端ChatGPT，请用进行第十二步，运行前端服务，按任意键继续..."
            ;;
        12)
            echo "启动Web版前端ChatGPT"
            docker exec -it wechatgpt /bin/bash -c "cd /chatgpt-web && nohup sh -c 'export PATH=$PATH:/usr/local/bin && export NODE_ENV=production && pnpm dev > log.out 2>&1 &'"
            # 在这里添加运行微信版ChatGPT的命令
            read -n 1 -s -r -p "已经运行成功Web版ChatGPT，请用ip:1002访问，按任意键继续..."
            ;;

        13)
        PROCESS_NAMES=("pnpm start" "pnpm dev")
for PROCESS_NAME in ${PROCESS_NAMES[@]}; do
PID=$(pgrep -f "$PROCESS_NAME")
if [ -n "$PID" ]; then
 echo "Killing process $PID with name $PROCESS_NAME"
 kill $PID
else
 echo "Process $PROCESS_NAME is not running"
fi
done

        PORTS=(3002 1002)
for PORT in ${PORTS[@]}; do
PID=$(lsof -ti :$PORT)
if [ -n "$PID" ]; then
echo "Killing process $PID on port $PORT"
kill $PID
else
echo "Port $PORT is not in use"
fi
done


            read -n 1 -s -r -p "已经结束运行Web端ChatGPT，按任意键继续..."
            ;;
        14)
            echo "卸载服务"
            docker stop wechatgpt
            docker rm wechatgpt
            docker rmi -f veelove/wetgchat:wetgchat1
            # 在这里添加运行微信版ChatGPT的命令
            read -n 1 -s -r -p "已经卸载完成，按任意键继续..."
            ;;
        q)
            echo "退出."
            exit
            ;;
        *)
            echo "无效选项, 请重新输入."
            read -n 1 -s -r -p "按任意键继续..."
            ;;
    esac
done
