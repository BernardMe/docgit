

# 缓存的实现



## Redis
五种数据类型
String(字符串)
List(列表)
Hash(字典)
Set(集合)
Sorted Set(有序集合)


### Redis的持久化
RDB 和 AOF
RDB持久化是指在指定的时间间隔内将内存中的数据集快照写入磁盘。
AOF是指redis会将每一个收到的写命令都通过write函数追加到文件中(默认是 appendonly.aof)。


### 配置Redis集群
使用“主-从模式”
![RedisCluster_Masters_Slaves](./RedisCluster_Masters_Slaves.png)

注意：配置好后 在iptables中放行端口，并重启iptables服务


#### Redis集群步骤
1.`# yum install ruby -y`
1.1 后面需要用到ruby脚本
2.`# yum install rubygems -y`
1.1 安装ruby包管理器
3.`# gem install redis-3.0.0.gem`
3.1 脚本需要ruby其他包,所以安装这个redis.gem
4.`# mkdir reids-cluster`
4.1 在/usr/local中新建redis-cluster文件夹
5.`# cp -r bin ../redis-cluster/redis01`
5.1 把之前安装好的redis/bin复制到redis-cluster中并起名为redis01
6.`# rm -rf dump.rdb`
6.1 删除掉redis01 中dump.rdb数据库文件
7.`# vi redis.conf` 
7.1 修改redis01中端口号为7001, 找到port 后面修改为7001
7.2 去掉cluster-enabled yes前面的注释
7.3 如果之前设置过密码,注释掉密码.如果没有设置过过略7.3这步骤
8.# 
```shell
cp -r redis01 redis02
cp -r redis01 redis03
cp -r redis01 redis04
cp -r redis01 redis05
cp -r redis01 redis06
```
8.1 把redis01文件夹在复制5份,分别起名为redis02,redis03,redis04,redis05,redis06
9`# vi redis02/redis.conf`
9.1 此命令需要在redis-cluster下执行
9.2 把其他5个文件夹中redis.conf中port修改成不同的值,分别为7002,7003,7004,7005,7006
10.`# cp *.rb /usr/local/redis-cluster/`
10.1 去redis解压目录中src下执行此命令
10.2 把redis-trib.rb复制到reids-cluster中.
11.`# vi startall.sh`
11.1 创建一个批量启动文件
11.2 把下面内容粘贴到文件中
```shell
      cd redis01
      ./redis-server redis.conf
      cd .. 
      cd redis02
      ./redis-server redis.conf
      cd .. 
      cd redis03
      ./redis-server redis.conf
      cd .. 
      cd redis04
      ./redis-server redis.conf
      cd .. 
      cd redis05
      ./redis-server redis.conf
      cd .. 
      cd redis06
      ./redis-server redis.conf
      cd .. 
```
12.`# chmod +x startall.sh`
12.1 给脚本设置一个可启动权限
13.`# ./startall.sh`
13.1 执行脚本,启动所有redis服务
14.# ps aux|grep redis
14.1 查看所有服务是否启动成功

15.`# ./redis-trib.rb create --replicas 1 192.168.192.130:7001 192.168.192.130:7002 192.168.192.130:7003 192.168.192.130:7004 192.168.192.130:7005  192.168.192.130:7006`
15.1 创建集群
15.2 在执行时按照提示输入’yes’
16.`# ./redis01/redis-cli -h 192.168.10.128 -p 7001 -c`
16.1 进入任意节点测试

17.`# redis01/redis-cli -p 7001 shutdown`
17.1 关闭其中一个redis

18.# vi shutdown.sh
18.1 在redis-cluster中创建文件,并添加下面内容
```shell
      ./redis01/redis-cli -p 7001 shutdown
      ./redis02/redis-cli -p 7002 shutdown
      ./redis03/redis-cli -p 7003 shutdown
      ./redis04/redis-cli -p 7004 shutdown
      ./redis05/redis-cli -p 7005 shutdown
      ./redis06/redis-cli -p 7006 shutdown
```


## Redis经典功能设计

### 基于redis实现世界杯排行榜功能项目

#### 需求

前段时间，做了一个世界杯竞猜积分排行榜。对世界杯64场球赛胜负平进行猜测，猜对+1分，错误+0分，一人一场只能猜一次。

1.展示前一百名列表。
2.展示个人排名(如：张三，您当前的排名106579)。


#### 分析

一开始打算直接使用mysql数据库来做，遇到一个问题，每个人的分数都会变化,如何能够获取到个人的排名呢？数据库可以通过分数进行row_num排序，但是这个方法需要进行全表扫描，当参与的人数达到10000的时候查询就非常慢了。

redis的排行榜功能就完美锲合了这个需求。来看看我是怎么实现的吧。







