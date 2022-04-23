### mysql官网
https://dev.mysql.com/doc/refman/8.0/en/
### 概念
1. 真实环境主从至少需要2台服务器，主从分开
2. 对于mysql基础环境到账户登入修改密码基本通用，注意my.cnf的server-i配置
3. 主从配置涉及到账户管理需要了解含义，对于数据库操作暴露给代码的账户可以设置指定ip，这里设置为%（不限ip）。

### 选择yum linux rpm
```
# 查询java 版本
# 按照版本对比系统https://access.redhat.com/articles/3078 这里对应的是 Linux 7
cat /proc/version 
"Linux version 3.10.0-957.12.2.el7.x86_64"

# https://dev.mysql.com/downloads/repo/yum/  对照linux7对应的Mysql版本
"mysql80-community-release-el7-3.noarch.rpm"
```

### 根据查询的Mysql版本安装MySQL
###### 切换到download目录，如果没有就 mkdir download 统一管理下载文件
```
cd download
wget https://repo.mysql.com//mysql80-community-release-el7-3.noarch.rpm
```
###### 安装mysql yum 仓库
    sudo rpm -Uvh mysql80-community-release-el7-3.noarch.rpm
###### 安装mysql社区版
    sudo yum install mysql-community-server
###### 修改配置文件
```
# 查找配置文件地址,一般centos为/etc/my.cnf
whereis my.cnf
# 找到后
vim /etc/my.cnf
# 添加一下指令
server-id=1   (主从2个id需要不一样)
log-bin=mysql-bin  （从库可以不要）
expire_logs_days = 7 （从库可以不要）
```
###### 启动mysql
    sudo service mysqld start
###### 查看状态
```
sudo service mysqld status

● mysqld.service - MySQL Server
   Loaded: loaded (/usr/lib/systemd/system/mysqld.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2019-06-26 17:09:24 CST; 4min 12s ago
     Docs: man:mysqld(8)
           http://dev.mysql.com/doc/refman/en/using-systemd.html
  Process: 31149 ExecStartPre=/usr/bin/mysqld_pre_systemd (code=exited, status=0/SUCCESS)
 Main PID: 31228 (mysqld)
   Status: "SERVER_OPERATING"
   CGroup: /system.slice/mysqld.service
           └─31228 /usr/sbin/mysqld

Jun 26 17:09:14 instance-4a1cr95u-2 systemd[1]: Starting MySQL Server...
Jun 26 17:09:24 instance-4a1cr95u-2 systemd[1]: Started MySQL Server.
```
### 登录mysql并设置参数
###### 设置临时密码并登入
```
# 设置临时root密码
sudo grep 'temporary password' /var/log/mysqld.log
# 展示如下 password为 J:;9WkZDolbS
2021-06-26T09:09:20.424139Z 5 [Note] [MY-010454] [Server] A temporary password is generated for root@localhost: J:;9WkZDolbS

```
###### 使用临时密码登入并创建账户
```
# 登入mysql
mysql -u root -p

# 修改root密码，密码默认需要大小写字符等，建议用在线生成器生成，简单的密码建不了
ALTER USER 'root'@'localhost' IDENTIFIED BY '密码'

# 创建新用户（ps:root账户最好不要运用到数据库连接）
CREATE USER '用户名'@'%' IDENTIFIED BY '密码';

# 用户授权
GRANT ALL  ON *.* TO '用户名'@'%'; 

# 刷新特权
FLUSH PRIVILEGES;

```


### 按照以上流程在2台服务器上分别安装MySQL
##### 主从配置
身份 | 内网地址 | 
---|--- |
 master | 192.168.0.13:3306
 slave | 192.168.0.14:3306
##### 主节点创建同步账户
```
# 创建指定ip同步用账户
CREATE USER '同步账户'@'192.168.0.13' IDENTIFIED WITH mysql_native_password BY '密码';
# 授同步权限
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'192.168.0.13';
# 刷新权限
FLUSH PRIVILEGES;
```
##### 从节点配置
```
# 设置从库跟随配置
change master to
master_host='192.168.0.14',#要连接的主服务器的ip
master_user='同步账户',#指定的用户名，最好不要用root
master_port=3306,#主库3306映射的端口
master_password='密码';#主库要连接的用户的密码了
# 启动从库设置
start slave ;
# 查看状态
show slave status \G;
```

##### 创建从库只读用户
```
CREATE USER '用户名'@'%' IDENTIFIED BY '密码'; 

GRANT SELECT ON *.* TO '用户名'@'%'; 

FLUSH PRIVILEGES;

```

##### 设置mysql 连接数
```
# 查询连接数
show variables like 'max_connections';
#修改连接数
set global max_connections=5000;
```
