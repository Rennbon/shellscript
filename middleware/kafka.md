### 下载kafka
```
# 切换到download目录
cd /root/download
# 下载kafka压缩包 
wget http://mirror-hk.koddos.net/apache/kafka/2.3.0/kafka_2.11-2.3.0.tgz
# 解压到指定目录 /root/env/kafka
tar -xzf /root/download/kafka_2.11-2.3.0.tgz -C /root/env/kafka/
# 切换到kafka目录
cd  /root/env/kafka/kafka_2.11-2.3.0

```
### 修改配置
```
# 修改zookeeper并发请求限制
vim /root/kafka/kafka_2.11-2.2.0/config/zookeeper.properties
# 修改默认1为0 
zookeeper.properties=0

# 修改服务配置
vim /root/kafka/kafka_2.11-2.2.0/config/server.properties
# 参数修改，这边统一设置为0.0.0.0，如果服务器端口暴露给外网需要设定为指定ip
listeners=PLAINTEXT://0.0.0.0:9092
# 新增 ip需要是内网地址，不接受0.0.0.0
advertised.listeners=PLAINTEXT://192.168.0.14:9092
zookeeper.connect=0.0.0.0:2181

```
### 启动zookeeper和kafka

```
cd /root/env/kafka/kafka_2.11-2.3.0
nohup bin/zookeeper-server-start.sh config/zookeeper.properties &
nohup bin/kafka-server-start.sh config/server.properties &
```

### 创建topic
```
bin/kafka-topics.sh --create --bootstrap-server 0.0.0.0:9092 --replication-factor 1 --partitions 1 --topic dolphinhub
```
### 查询topic
```
bin/kafka-topics.sh --describe --zookeeper 0.0.0.0:2181 --topic topicname
```
### 查询topic列表
```
bin/kafka-topics.sh --zookeeper 0.0.0.0:2181 --list
```

### 修改kafka log过期时间
```
bin/kafka-configs.sh --zookeeper 0.0.0.0:2181 –entity-type topics –entity-name "topicname" –alter –add-config log.retention.hours=120
```

### 查询log offset
```
bin/kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list 0.0.0.0:9092 --topic "topicName" --time -1
```
