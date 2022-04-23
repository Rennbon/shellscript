### 官网
https://docs.mongodb.com

### 概念
1. replica set 默认最少3个节点，1个primary节点，2个secondary节点
2. 真实环境3个节点最好分布在3台服务器
3. 对于replica set的账户其实只有一个

###  yum安装mongodb
###### 设置yum 关于mongodb版本配置
```
# 编辑配置
vim /etc/yum.repos.d/mongodb-org-4.0.repo
# 填写配置如下，这里用最新mongo 4.0
[mongodb-org-4.0]
name=MongoDB Repository
# 官方仓库
#baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.0/x86_64/
# 阿里镜像
baseurl=http://mirrors.aliyun.com/mongodb/yum/redhat/$releasever/mongodb-org/4.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.0.asc

# 安装最新稳定版
sudo yum install -y mongodb-org
```
###### 创建keyfile
> 这里多个节点的mongo_key_file 内容都是同一份
```
cd /etc
openssl rand -base64 756 > mongo_key_file
chmod 400 mongo_key_file
chown -R mongod:mongod /etc/mongo_key_file
```
###### 修改mongod.conf

> 修改绑定ip地址，全部0.0.0.0,安全策略不可配置外网端口\
新增replication配置

```
vim /etc/mongod.conf

#增加以下内容
net:
  port: 27017
  bindIp: 0.0.0.0  # Enter 0.0.0.0,:: to bind to all IPv4 and IPv6 addresses or, alternatively, use the net.bindIpAll setting.

security:
  keyFile: /etc/mongo_key_file

replication:
  oplogSizeMB: 10240
  replSetName: rs0
  secondaryIndexPrefetch: all

```


###### 启动mongo
```
# 启动mongo
sudo service mongod start

# 进入mongo
mongo

# 执行节点绑定
config={"_id":"rs0","members":[
{
    "_id":0,
    "host":"192.168.0.14:27017"
},
{
    "_id":1,
    "host":"192.168.0.13:27017"
},
{
    "_id":2,
    "host":"192.168.0.11:27017"
},
]}
rs.initiate(config)

# 查询状态
db.isMaster()
# 创建账户
use admin
db.createUser({ user: '账户名', pwd: '密码', roles: [ { role: "root", db: "admin" } ] });

# 登入数据库
db.auth("账户名","密码")
```
