#! /bin/bash

#---------------------------
# 等到命令运行成功
# 调用方式： ./waitcmd.sh root "./click star"
# 参数描述：
#  $1:user 用户
#  $2:cmd 需要启动的指令
#---------------------------
echo user:$1 shell:$2
result=0
while [ $result -lt 1 ] ;do
    sleep 1s
    result=`ps -u $1 x| grep "$2" | grep -v 'grep\|waitcmd.sh' | wc -l`
    echo -e "\033[46;37m wait process start... \033[0m"
done
