

# 准备工作




# 安装步骤

## 磁盘分区

### 磁盘分区模式
，选择Create custom layout （建立自定义的分区结构）

说明：在对磁盘进行分区之前，要先规划好如何分区，每个分区设置多大

我这里的分区如下

### 根分区
/ 5G(5120MB)

#### Mount Point（挂载点）： /

File System Type（文件系统类型）：ext3

Size（MB）大小：5120

Additional Size Options（其它大小选项）

选择：Fixed size（固定大小）

### swap分区
/swap 1G(1024MB)  
swap一般建议为物理内存的2倍大小

### data分区
/data 剩余所有磁盘空间80%

### /backup分区
/backup 剩余所有磁盘空间20%

备注：/data单独分区，用来存放数据，也可以再单独划分一个/backup用来备份数据。

建议：所有的数据都单独分区，这样做的好处是，如果系统出现问题，不会影响到数据，或者需要重装系统，数据不用转移。


## 软件选择界面
，取消Desktop – Gnome前面的勾

备注：服务器系统采用最小话安装，不安装任何软件包






# 设置IP地址、网关DNS

输入账号root
再输入安装过程中设置的密码，登录到系统
`vi  /etc/sysconfig/network-scripts/ifcfg-eth0   #编辑配置文件,添加修改以下内容`

```shell
BOOTPROTO=static   #启用静态IP地址
ONBOOT=yes  #开启自动启用网络连接
IPADDR=192.168.21.128    #设置IP地址
NETMASK=255.255.255.0  #设置子网掩码
GATEWAY=192.168.21.2    #设置网关
:wq!  #保存退出
```

`vi /etc/resolv.conf   #编辑配置文件，添加修改以下内容`

```shell
nameserver 8.8.8.8  #设置主DNS
nameserver 8.8.4.4  #设置备用DNS
:wq!  #保存退出
```

`service network restart  #重启网络服务`



# 设置主机名

hostname  www  #设置主机名为www

`vi /etc/sysconfig/network  #编辑配置文件`

```shell
HOSTNAME=www  #修改localhost.localdomain为www
:wq!  #
```

`vi /etc/hosts #编辑配置文件`

```shell
127.0.0.1  www localhost  #修改localhost.localdomain为www
:wq!  #保存退出
```

`shutdown –r now  #重启系统`

至此，CentOS 5.5系统安装完成。





