

# MongoDB

## MongoDB的基本概念

MongoDB的数据单元是文档，可以看作JavaScript中的对象，类似于关系数据库中的行。
集合类似于关系数据库中的表，区别在于没有模式
每个MongoDB数据库都有自身的集合和权限
MongoDB的操作主要靠终端的JavaScript Shell完成


## 文档
在JavaScript中，文档表示为对象：

{"name": "XueSeason", "age": 22}
以上文档有一个name键，其值为XueSeason，age键值为22。
从这个文档，解释了几个概念：

文档中的键值对是有序的，上面例子中如果调换name和age的键值对，将会被视为一个全新的文档
文档中的值不仅仅只限于字符串形式，还有其他更高级的类型
文档的键使用UTF-8字符。其中`.和$`通常被保留，只有在特定环境下使用，`_`也是保留的


## 集合
集合就是文档集，作为NoSQL是区别于关系数据库的表。

### 无模式
集合是无模式的。即不同类型的文档可以共存于同一个集合中
```js
{"name": "XueSeason", "age": 22}
{"book": "The old man and the Sea"}
```
注意上面的文档是完全不同的两个文档。既然一个集合可以容纳各种类型，为何需要多集合？
使用多集合的意义在于：
降低熵值。即减少混乱程度。
速度上的优越性。把一个特定类型的文档分成多个子集合提高查询效率。
把同种类型的文档存在一个集合汇总，使数据更集中。

推荐尽量使用子集合来组织数据。


## 命名
集合名不能为空字符串。
不能含有\0字符。
不能以system.开头，系统集合的保留前缀。
不能含有保留字符$



## MongoDB的安装及配置 

### Windows版本

（1）. 登录Mongodb官网点击下载

（2）. 将zip文件解压放到盘符的根目录（如C：或D：），为了方便建议文件夹命名尽量简短如（d:\mongodb），确定MongoDB主目录`D:\MongoDB\Server`

（3）. 创建数据库文件的存放位置，比如d:/mongodb/data/db。启动mongodb服务之前需要必须创建数据库文件的存放文件夹，否则命令不会自动创建，而且不能启动成功。

（4）. 打开cmd命令行，进入D:\mongodb\bin目录（如图先输入d:进入d盘然后输入cd d:\mongodb\bin），

输入如下的命令启动mongodb服务：

`D:/mongodb/bin>mongod --dbpath D:\mongodb\data\db`
（5）. mongodb默认连接端口27017，如果出现如图的情况，可以打开http://localhost:27017查看（笔者这里是chrome），发现如图则表示连接成功，如果不成功，可以查看端口是否被占用。

（6）. 其实可以将MongoDB设置成Windows服务，这个操作就是为了方便，每次开机MongoDB就自动启动了。

在d:\mongodb\data下新建文件夹log（存放日志文件）并且新建文件mongodb.log
在d:\mongodb新建文件mongo.config

在mongo.config中输入：
```shell
dbpath=D:\mongodb\data\db
logpath=D:\mongodb\log\mongo.log  
```
（7）. 用管理员身份打开cmd命令行，进入D:\mongodb\bin目录，输入如下的命令：

`D:\mongodb\bin>mongod --config D:\mongodb\mongo.config `
如图结果存放在日志文件中，查看日志发现已经成功。如果失败有可能没有使用管理员身份，遭到拒绝访问。

（8）. 打开cmd输入services.msc查看服务可以看到MongoDB服务，点击可以启动
若以上没有添加mongo服务，则命令行添加：

cd D:\MongoDB\bin
`mongod --dbpath D:\MongoDB\data\db --logpath=D:\MongoDB\log\mongo.log --install`

启动服务即可：
到服务中启mongodB（或者cmd命令提示符下输入：`net start mongodb` 即可启动mongodb了）

删除服务：
管理员模式打开cmd,输入 sc delete mongodb 即可删除mongodb服务

### MongoDB给数据库创建用户

#### 先以非授权的模式启动MongoDB
非授权：

linux/Mac : `mongod -f /mongodb/etc/mongo.conf`

windows  : `mongod --config c:\mongodb\etc\mongo.conf ` 或者  net start mongodb （前提是mongo安装到了服务里面）

备注：
/mongodb/etc/mongo.conf 位mongo配置文件所在的地址

授权：
mongod -f /mongodb/etc/mongo.conf --auth

备注：
1.--auth代表授权启动，需要帐号密码才能访问
2.auth=true可以加到mongo.conf配置文件里面去进行统一管理

#### 创建管理员

1.通过非授权的方式启动mongo

2.创建admin数据库
`use admin`

3.添加管理员用户
`db.createUser({user:"admin",pwd:"123456",roles:["root"]})`
备注：用户名和密码可随意定

4.认证
`db.auth("admin", "123456")`

#### 以授权的方式启动Mongo,给使用的数据库添加用户
1.切换数据库
use test

2.创建用户
db.createUser({user: "root", pwd: "123456", roles: [{ role: "dbOwner", db: "test" }]})

3.通过客户端连接test数据库


##　启动MongoDB
确保你成功安装MongoDB并且正确配置。
终端输入mongod命令
如果出现类似以下信息：

```shell
2015-03-28T13:35:04.067+0800 W -        [initandlisten] Detected unclean shutdown - /data/db/mongod.lock is not empty.
2015-03-28T13:35:04.067+0800 I STORAGE  [initandlisten] exception in initAndListen: 98 Unable to lock file: /data/db/mongod.lock errno:35 Resource temporarily unavailable. Is a mongod instance already running?, terminating
2015-03-28T13:35:04.067+0800 I CONTROL  [initandlisten] dbexit:  rc: 100
```
表明已经有一个MongoDB程序在后台运行。
可以通过ps -ef查找到相关的pid，执行kill [pid]强制关闭。
MongoDB在没有参数的情况下默认会使用/data/db目录，并监听27017端口
如果该目录不存在或者不可写，服务器也会启动失败。








