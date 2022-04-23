# centos 配置 supervisor
- https://github.com/Supervisor/supervisor
## 1. 安装
```
# 更新到最新软件包
yum update -y

# step 1 安装EPEL存储库，引文supervisor在默认的CentOS 7存储库中不可用  
yum install epel-release

# step 2 安装完EPEL后更新系统包，然后安装supervisor
yum update 
yum install supervisor -y

# step 3 创建sock文件
cd /var/run/supervisor/
touch supervisor.sock
chmod 777 supervisor.sock
```
## 2. supervisor cmd
```
# 启停supervisor
systemctl start supervisord
systemctl enable supervisord
# 查看状态
systemctl status supervisord
```

## 3. 应用配置（基础要求）
```toml
[program:dtm]
# 启动命令
command=/data/app/dtm -c /data/app/conf.yml
# 权重，程序启停优先级，LIFO
priority=1
# 启动前cd到这个文件夹
directory=/data/app
# 随supervisord重启而重启
autorestart=true
# 随supervisord启动而启动
autostart=true
# 错误日志位置
stderr_logfile=/data/app/error.log
# 错误日志容量上限
stderr_logfile_maxbytes=2GB
stdout_logfile=/data/app/stdout.log
stdout_logfile_maxbytes=1GB
# 环境变量指定
environment=
# 启动用户
user=root
# 启动后等待指定时间后标记程序启动成功
startsecs=10
# 启动重试次数
startretries=3

```
