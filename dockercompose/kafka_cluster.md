## kafka cluster
### 1. 设置docker network
```
docker network create --subnet 172.12.0.0/16 --gateway 172.12.0.1 zookeeper_kafka
```
### 2. zoo.cfg
```
# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just
# example sakes.
dataDir=/data
dataLogDir=/datalog
# the port at which the clients will connect
clientPort=2181
# the maximum number of client connections.
# increase this if you need to handle more clients
#maxClientCnxns=60
#
# Be sure to read the maintenance section of the
# administrator guide before turning on autopurge.
#
# http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
#
# The number of snapshots to retain in dataDir
autopurge.snapRetainCount=3
# Purge task interval in hours
# Set to "0" to disable auto purge feature
autopurge.purgeInterval=1
server.1= zoo1:2888:3888
server.2= zoo2:2888:3888
server.3= zoo3:2888:3888

```
### 3. docker-compose.yml
```
version: '3'

services:
  zoo1:
    image: zookeeper
    restart: always
    hostname: zoo1
    container_name: zoo1
    volumes:
      - "./zoo.cfg:/conf/zoo.cfg"
      - "./z1/datalog:/datalog"
      - "./z1/data:/data"
    ports:
      - "2181:2181"
    environment:
      TZ: Asia/Shanghai
      ZOO_MY_ID: 1
      ZOO_SERVERS: server.1=zoo1:2888:3888 server.2=zoo2:2888:3888 server.3=zoo3:2888:3888
    networks:
      default:
        ipv4_address: 172.12.0.11
  zoo2:
    image: zookeeper
    restart: always
    hostname: zoo2
    container_name: zoo2
    volumes:
      - "./zoo.cfg:/conf/zoo.cfg"
      - "./z2/datalog:/datalog"
      - "./z2/data:/data"
    ports:
      - "2182:2181"
    environment:
      TZ: Asia/Shanghai
      ZOO_MY_ID: 2
      ZOO_SERVERS: server.1=zoo1:2888:3888 server.2=zoo2:2888:3888 server.3=zoo3:2888:3888
    networks:
      default:
        ipv4_address: 172.12.0.12
  zoo3:
    image: zookeeper
    restart: always
    hostname: zoo3
    container_name: zoo3
    volumes:
      - "./zoo.cfg:/conf/zoo.cfg"
      - "./z3/datalog:/datalog"
      - "./z3/data:/data"
    ports:
      - "2183:2181"
    environment:
      TZ: Asia/Shanghai
      ZOO_MY_ID: 3
      ZOO_SERVERS: server.1=zoo1:2888:3888 server.2=zoo2:2888:3888 server.3=zoo3:2888:3888
    networks:
      default:
        ipv4_address: 172.12.0.13

  broker1:
    image: wurstmeister/kafka:2.12-2.4.1
    restart: always
    container_name: broker1
    ports:
      - "19092:9092"
    environment:
      TZ: Asia/Shanghai
      KAFKA_BROKER_ID: 0
      KAFKA_LISTENERS: PLAINTEXT://0.0.0.0:9092
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://122.51.124.129:19092
      KAFKA_ZOOKEEPER_CONNECT: zoo1:2181,zoo2:2181,zoo3:2181
    volumes:
      - /opt/docker/kafka-cluster/b1:/kafka
    links:  # 连接本compose文件以外的container
      - zoo1
      - zoo2
      - zoo3
    networks:
      default:
        ipv4_address: 172.12.0.14

  broker2:
    image: wurstmeister/kafka:2.12-2.4.1
    restart: always
    container_name: broker2
    ports:
      - "19093:9092"
    environment:
      TZ: Asia/Shanghai
      KAFKA_BROKER_ID: 1
      KAFKA_LISTENERS: PLAINTEXT://0.0.0.0:9092
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://122.51.124.129:19093
      KAFKA_ZOOKEEPER_CONNECT: zoo1:2181,zoo2:2181,zoo3:2181
    volumes:
      - /opt/docker/kafka-cluster/b2:/kafka
    links:  # 连接本compose文件以外的container
      - zoo1
      - zoo2
      - zoo3
    networks:
      default:
        ipv4_address: 172.12.0.15

  broker3:
    image: wurstmeister/kafka:2.12-2.4.1
    restart: always
    container_name: broker3
    ports:
      - "19094:9092"
    environment:
      TZ: Asia/Shanghai
      KAFKA_BROKER_ID: 2
      KAFKA_LISTENERS: PLAINTEXT://0.0.0.0:9092
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://122.51.124.129:19094
      KAFKA_ZOOKEEPER_CONNECT: zoo1:2181,zoo2:2181,zoo3:2181
    volumes:
      - /opt/docker/kafka-cluster/b3:/kafka
    links:  # 连接本compose文件以外的container
      - zoo1
      - zoo2
      - zoo3
    networks:
      default:
        ipv4_address: 172.12.0.16

  kafka-manager:
    image: sheepkiller/kafka-manager:latest
    restart: always
    container_name: kafka-manager
    hostname: kafka-manager
    ports:
      - "9000:9000"
    links:      # 连接本compose文件创建的container
      - broker1
      - broker2
      - broker3
      - zoo1
      - zoo2
      - zoo3
    environment:
      TZ: Asia/Shanghai
      ZK_HOSTS: zoo1:2181,zoo2:2181,zoo3:2181
      KAFKA_BROKERS: broker1:19092,broker2:19093,broker3:19094
      APPLICATION_SECRET: letmein
      KAFKA_MANAGER_AUTH_ENABLED: "true" # 开启验证
      KAFKA_MANAGER_USERNAME: "admin" # 用户名
      KAFKA_MANAGER_PASSWORD: "admin" # 密码
      KM_ARGS: -Djava.net.preferIPv4Stack=true
    networks:
      default:
        ipv4_address: 172.12.0.17

networks:
  default:
    external:
      name: zookeeper_kafka


```
