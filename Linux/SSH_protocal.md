

## 什么是协议

### SSH协议(Secure Shell)

ssh是“Secure Shell”的简写
Secure Shell协议是国际互联网工程任务组（The Internet Engineering Task Force，简称 IETF）制定的一个标准。
目的是为了创建一个工作在应用层和传输层基础上的安全协议。避免数据段明文传输。


什么是OpenSSH？ 前边说了，ssh是网络协议，而OpenSSH就是其中的一个具体实现。
OpenSSH是跨平台的，支持linux, unix*,甚至windows。所以在实际应用中，我们用到的基本上都是OpenSSH


OpenSSH有哪些功能？ Secure Shell 是一个通信协议，在这个协议之上可以是心啊很多应用层协议。从OpenSSH官网来看，OpenSSH提供了一下几个应用：
ssh 登录远程服务器， 在远程服务器上执行命令
scp 在两台主机之间实现文件拷贝。
sftp 基于openSSH实现的类似ftp程序

### 配置和启动ssh服务：
在使用之前我们需要对ssh服务进行配置，在大多数linux系统中，ssh服务的配置文件为：/etc/ssh/sshd_config 使用vim进行编辑：

vim  /etc/ssh/sshd_config
以下地方根据实际情况进行修改（yes为允许、no为禁止）：

PermitRootLogin yes  #是否允许root账户登录
PasswordAuthentication yes  #是否允许使用密码校验登录
RSAAuthentication yes  
PubkeyAuthentication yes  #是否允许使用key登录
然后使用系统服务管理命令启动服务，在大部分linux系统下，命令为：service 或者 systemctl 启动ssh服务命令：

~# service sshd restart














 

