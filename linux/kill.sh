#! /bin/bash

#---------------------------
# 查杀脚本（包括子线程）
# 调用方式： ./kill.sh root "./click star"
# 参数描述：
#  $1:user 用户
#  $2:cmd 指令，字符串包含即可，需要确保命中唯一
#---------------------------
echo user:$1 shell:$2
result=`ps -u $1 x| grep "$2" | grep -v 'grep\|kill.sh' | wc -l`
echo "There are $result processes match requirements"
ps -u $1 x| grep "$2" | grep -v 'grep\|kill.sh'
while [ $result -gt 0 ]; do
    # 存在，杀掉
    PID=`ps -u $1 x| grep "$2" | grep -v 'grep\|kill.sh' | awk '{print $1}'|sed -n 1p`
    kill -TERM $PID
    while kill -0 $PID; do
        sleep 1s
    done
    echo "the process $PID has been killed"
    result=`ps -u $1 x| grep "$2" | grep -v 'grep\|kill.sh' | wc -l`
    echo "There are $result processes match requirements"
done
echo -e "\033[46;37m cleaned up \033[0m"
