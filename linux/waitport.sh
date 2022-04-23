#! /bin/bash

#---------------------------
# 等待端口启动成功
# 调用方式： ./waitport.sh 8888"
# 参数描述：
# $1:port 端口号
#---------------------------
echo port:$1
result=0
while [ $result -lt 1 ] ;do
    sleep 3s
    result=`netstat -tunlp | grep "$1"|wc -l`
    echo -e "\033[46;37m wait port start... \033[0m"
done
