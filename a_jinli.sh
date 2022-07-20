# export JD_LOG_XYZ_TOKEN="从机器人获取的token"
# export KOIS_PINS="第1个要助力的pin&第2个要助力的pin" # 英文'&'分隔
# export Proxy_Url="代理网址 例如：星空、熊猫 生成选择txt 一次一个"
# export AUTO_OPEN_JINLI_READPACKET="true" # 助力满自动开红包，默认不开
# export JINLI_REDPACKET_IDS="要助力的红包ID&要助力的红包ID" # 英文'&'分隔，设置了此变量就直接助力,不获取助力码了
# 在青龙里新建一个定时任务，名称、定时规则随意，命令：task /ql/scripts/a_jinli.sh
chmod +x BBK
./BBK -t jinli
