# docker-compose.yml
## 单点
```yml
version: '3.1'

services:
  db:
    image: mongo:latest
    container_name: mongo
    restart: always
    environment:
      - MONGO_INITDB_ROOT_USERNAME=root
      - MONGO_INITDB_ROOT_PASSWORD=111111
      - TZ=Asia/Shanghai
    volumes:
      - "/opt/docker/mongo/data:/data/db"
    ports:
      - "27017:27017"

```
##  docker mongo replica set
```
// 生成用户keyfile 并修改权限
openssl rand -base64 756 > key_file
chmod 400 key_file

#
docker run  --name mongo0 \
--hostname mongo0 \
--net mongo-network \
-v /root/jbs-server/docker/db/mdb/mongo0/:/data/db \
-v /root/jbs-server/docker/db/mdb/key_file:/data/configdb/key_file \
-e "TZ=Asia/Shanghai" \
-p 27017:27017 -d  mongo:4.2 \
mongod --dbpath /data/db \
--replSet rs0 --oplogSize 128 \
--auth --keyFile=/data/configdb/key_file
 

docker run  --name mongo1 \
--hostname mongo1 \
--net mongo-network \
-v /root/jbs-server/docker/db/mdb/mongo1/:/data/db \
-v /root/jbs-server/docker/db/mdb/key_file:/data/configdb/key_file \
-e "TZ=Asia/Shanghai" \
-p 27018:27017 -d  mongo:4.2 \
mongod --dbpath /data/db \
--replSet rs0 --oplogSize 128 \
--auth --keyFile=/data/configdb/key_file


docker run  --name mongo2 \
--hostname mongo2 \
--net mongo-network \
-v /root/jbs-server/docker/db/mdb/mongo2/:/data/db \
-v /root/jbs-server/docker/db/mdb/key_file:/data/configdb/key_file \
-e "TZ=Asia/Shanghai" \
-p 27019:27017 -d  mongo:4.2 \
mongod --dbpath /data/db \
--replSet rs0 --oplogSize 128 \
--auth --keyFile=/data/configdb/key_file


//创建网络
docker network create mongo-network

//启动node1
docker run --name mongo1 \
-v /env/mongo/rs0/db1/:/data/db  \
-v /env/mongo/rs0/key_file:/data/key_file \
-p 27017:27017 -d mongo:4.1.11 \
-f /etc/mongo.conf
mongod --dbpath /data/db \
--replSet rs0 --oplogSize 128 \
--auth --keyFile=/data/key_file 
--net mongo-network \



//启动node2
docker run --name mongo2 \
-v /env/mongo/rs0/db2/:/data/db \
-v /env/mongo/rs0/key_file:/data/key_file \
-p 27018:27017 -d mongo:4.1.11 \
mongod --dbpath /data/db \
--replSet rs0 --oplogSize 128 \
--auth --keyFile=/data/key_file 
--net mongo-network \
//启动node3
docker run  --name mongo3 \
-v /env/mongo/rs0/db3/:/data/db \
-v /env/mongo/rs0/key_file:/data/key_file \
-p 27019:27017 -d  mongo:4.1.11 \
mongod --dbpath /data/db \
--replSet rs0 --oplogSize 128 \
--auth --keyFile=/data/key_file \

docker network inspect mongo-network
//进度mongo shell
docker exec -it mongo1 mongo
//设置副本集config 通过docker network连接，但是外部用url来连接是会有问题

config={"_id":"rs0","members":[
{
    "_id":0,
    "host":"mongo1:27017"
},
{
    "_id":1,
    "host":"mongo2:27017"
},
{
    "_id":2,
    "host":"mongo3:27017"
},
]}
//初始化副本集配置
rs.initiate(config)

// 采用内部或者外部网络连接，这个可以给外部用
//mongodb://admin:111111@192.168.10.189:27017,192.168.10.189:27018/?replicaSet=rs0&readPreference=secondary的方式连接
config={"_id":"rs0","members":[
{
    "_id":0,
    "host":"192.168.10.189:27017"
},
{
    "_id":1,
    "host":"192.168.10.189:27018"
},
{
    "_id":2,
    "host":"192.168.10.189:27019"
},
]}
rs.initiate(config)


//创建用户登录及密码
db.createUser({ user: 'admin', pwd: '111111', roles: [ { role: "root", db: "admin" } ] });

db.auth('admin','111111')
//修改权限，可以改为非root权限
db.grantRolesToUser('admin',[{role:'root',db:'admin'}])
 
```
