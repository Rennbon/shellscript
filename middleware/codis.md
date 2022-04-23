#### 下载codis
```
# 切换路径
cd /root/download
# 下载安装包
wget https://github.com/CodisLabs/codis/releases/download/3.2.2/codis3.2.2-go1.9.2-linux.tar.gz -O codis.tar.gz

# 解压安装包
tar -zxf codis.tar.gz 

# 将bin文件移动到/bin目录
mv  codis/* /bin/

# 设置配置文件
将 https://github.com/CodisLabs/codis/tree/release3.2/config 目录下的文件下载到本地

# 将下载到本地的配置文件上传到服务器
scp -r /本地目录/* root@外网ip:/etc/
```
#### 编辑配置文件
- vim /etc/dashboard.toml （修改以下字段）
```
#coordinator_name = "filesystem"
#coordinator_addr = "/tmp/codis"
coordinator_name = "zookeeper"
coordinator_addr = "192.168.0.11:2181" 
coordinator_auth = ""
product_name = "产品名"
product_auth = "密码"
admin_addr = "0.0.0.0:18080"

```
- vim /etc/proxy.toml (修改以下字段)
```
product_name = "shellscript"
product_auth = "高强度code"
session_auth = "高强度code2"
admin_addr = "0.0.0.0:11080"
proto_type = "tcp4"
proxy_addr = "0.0.0.0:19000"
```

- vim /etc/redis.cnf （修改以下字段）
```
bind 192.168.0.11 
dir "/var/lib/codis"
requirepass "proxy.toml中的product_auth"
```

### 启动codis (双核机器)
```
# 启动dashboard
nohup codis-dashboard --ncpu=2 \
--config=/etc/dashboard.toml \
--log=/var/lib/codis/log/dashboard.log --log-level=WARN &

# 启动代理
nohup codis-proxy --ncpu=2 \
--config=/etc/proxy.toml \
--log=/var/lib/codis/log/proxy.log --log-level=WARN &

# 启动redis
nohup codis-server /etc/redis.conf &

# 关联dashboard和proxy,切换为online状态
codis-admin --dashboard=192.168.0.11:18080 --create-proxy --addr=192.168.0.11:11080

# 创建group  
codis-admin --dashboard=192.168.0.11:18080 --create-group --gid=1

# 把启动的redis添加到group1中
codis-admin --dashboard=192.168.0.11:18080 --group-add --gid=1 --addr=192.168.0.11:6379

# 将slot的全部比列分配给group1
codis-admin --dashboard=192.168.0.11:18080 --slot-action --create-range --beg=0 --end=1023 --gid=1

# 如果需要其他命令
codis-admin --dashboard=192.168.0.11:18080 --help

```

