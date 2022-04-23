### 不动目录
- linux的目录中有且只有一个根目录
- Linux的各个目录存放的内容是规划好的，不要乱放文件
- linux是以文件的形式管理我们的设备，因此Linux系统，一切皆为文件。



目录 | 作用 | 
---|---
/bin | 二进制可执行文件，常用命令一般都在这里
/dev| 设备文件
/etc |配置文件
/etc/opt|opt的配置文件
/home|用户的家目录
/lib | /bin  /sbin中二进制文件比较的库文件
/media | 可移除设备挂载点
/mnt | 临时挂载的文件系统。如u盘
/opt | 应用软件包
/proc | 虚拟文件系统，将内核与进程状态归档为文本文件
/root |超级用户的家目录
/sbin|必要的系统二进制文件，如init,ip,mount。普通用户执行不了
/tmp| 临时文件，在系统重启时目录中文件不会被保留
/usr| 系统应用程序，比较重要的目录/usr/local本地系统管理员软件安装目录。
/var | 变量文件-在正常运行的系统中其内容不断变化的文件，如日志，脱机文件和临时电子邮件文件。
/sys |linux2.6以后新出现的一个文件系统sysfs
/srv| service缩写，该目录存放一些服务启动之后需要提取的数据。
>bin  boot  data  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
