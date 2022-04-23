
# mysql无法远程连接问题
首先登陆到mysql命令行：
```
mysql -u root -p
```
进入之后选择mysql库，用户信息都存在这个库的user表中
```
use mysql;

select host, user, authentication_string, plugin from user;
```
可以看到，用户对应的主机是localhost，而不是%，所以不能连接。
处理方法：
1、授权root用户可以远程登陆
```
GRANT ALL ON *.* TO 'root'@'%';

```
2、刷新权限
```
flush privileges;
```
3、修改加密规则
```
ALTER USER 'root'@'localhost' IDENTIFIED BY 'yourpassword' PASSWORD EXPIRE NEVER; 

grant all privileges on *.* to root@localhost identified by 'YourNewPassword' with grant option;

```
4、更新 root 用户密码
```
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'yourpassword';
```
5、刷新权限

    FLUSH PRIVILEGES; 



### 全部指令
```
mysql -u root -p

use mysql;
select host, user, authentication_string, plugin from user;
GRANT ALL ON *.* TO 'root'@'%';
flush privileges;
ALTER USER 'root'@'localhost' IDENTIFIED BY '111111' PASSWORD EXPIRE NEVER; 
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '111111';
flush privileges;

```
