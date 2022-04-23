# linux新建用户及ssh登录配置

### 生成rsa,也可以ecdsa
    ssh-keygen -t rsa -f 名称 -C 注名  //local
### 新建用户并配置ssh登录
```
# 新建用户
useradd [name]

# 设置密码，可以不设
passwd [name]

# 创建新用户根目录
mkdir /home/[name]/.ssh

# 新用户根目录authorized_keys创建
touch /home/[name]/.ssh/authorized_keys

# 将指定目录权限变更给新用户
chown -R [name]. /home/[name]/.ssh

# 添加公钥到authorized_keys
cat rsa.pub >> /home/[name]/.ssh/authorized_keys

# 设置用户权限
chmod 700 /home/[name]/.ssh
chmod 600 /home/[name]/.ssh/authorized_keys

```

### 将rsa private key 复制需要远程登录的机器并修改为400权限
```
chmod 400 rsa
```

