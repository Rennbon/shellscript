#! /bin/bash

#---------------------------
# 脚本启动重试直到成功
# 调用方式： ./retry.sh root "./click star"
# 参数描述：
#  $1:user 用户
#  $2:cmd 需要启动的指令
#---------------------------
echo user:$1 shell:$2
while timeout -k 70 $1 bash -c "$2" ; [ $? = 124 ]
do
    echo -e "\033[46;37m timeout retry \033[0m"
    sleep 2s
done
