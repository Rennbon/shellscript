### 下载zookeeper安装包
###### 新建目录并切换
    mkdir -p /root/env/zookeeper
    cd /root/env/zookeeper
###### 下载kafka安装包
    wget http://mirror-hk.koddos.net/apache/zookeeper/zookeeper-3.5.5/apache-zookeeper-3.5.5.tar.gz -O zookeeper.tar.gz
###### 解压安装包
    tar -zxf zookeeper.tar.gz
###### 进入zookeeper目录
    cd zookeeper
###### 创建单点config
    cp conf/zoo_sample.cfg conf/zoo.cfg
###### 修改zoo.cfg参数
```
vim /cnf/zoo.cfg 

# 修改路径
dataDir=/var/lib/zookeeper/data
# log路径区分开，能加速zookeeper计算
dataLogDir=/var/lib/zookeeper/log

```
###### 启动zookeeper
    bin/zkServer.sh start
