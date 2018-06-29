

# MongoDB

## MongoDB的基本概念

MongoDB的数据单元是文档，可以看作JavaScript中的对象，类似于关系数据库中的行。
集合类似于关系数据库中的表，区别在于没有模式
每个MongoDB数据库都有自身的集合和权限
MongoDB的操作主要靠终端的JavaScript Shell完成

### MongoDB GridFS
GridFS 用于存储和恢复那些超过16M（BSON文件限制）的文件(如：图片、音频、视频等)。

GridFS 也是文件存储的一种方式，但是它是存储在MonoDB的集合中。

GridFS 可以更好的存储大于16M的文件。

GridFS 会将大文件对象分割成多个小的`chunk(文件片段)`,一般为256k/个,每个chunk将作为MongoDB的一个文档(document)被存储在`chunks集合`中。

GridFS 用两个集合来存储一个文件：fs.files与fs.chunks。

每个文件的实际内容被存在chunks(二进制数据)中,和文件有关的`meta数据(filename,content_type,还有用户自定义的属性)`将会被存在`files集合`中。


以下是简单的fs.files集合文件
```js
   "filename": "test.txt",
   "chunkSize": NumberInt(261120),
   "uploadDate": ISODate("2014-04-13T11:32:33.557Z"),
   "md5": "7b762939321e146569b07f72c62cca4f",
   "length": NumberInt(646)
```

以下是简单的fs.chunks集合文件
```js
   "files_id": ObjectId("534a75d19f54bfec8a2fe44b"),
   "n": NumberInt(0),
   "data": "Mongo Binary Data"
```

#### GridFS 添加文件
现在我们使用 GridFS 的 put 命令来存储 mp3 文件。 调用 MongoDB 安装目录下bin的 mongofiles.exe工具。
打开命令提示符，进入到MongoDB的安装目录的bin目录中，找到mongofiles.exe，并输入下面的代码：
`mongofiles.exe -d gridfs put song.mp3`

GridFS 是存储文件的数据名称。如果不存在该数据库，MongoDB会自动创建。Song.mp3 是音频文件名。
使用以下命令来查看数据库中文件的文档：
`db.fs.files.find()`
以上命令执行后返回以下文档数据：
```js
{
   _id: ObjectId('5b17866403b6c204b0337f27'), 
   filename: "song.mp3", 
   chunkSize: 261120, 
   uploadDate: new Date(1397391643474), md5: "e4f53379c909f7bed2e9d631e15c1c41",
   length: 10401959 
}
```
我们可以看到 fs.chunks 集合中所有的区块，以下我们得到了文件的_id 值，我们可以根据这个_id 获取区块(chunk)的数据：
`db.fs.chunks.find({files_id:ObjectId('5b17866403b6c204b0337f27')})`
以上实例中，查询返回了 40 个文档的数据，意味着mp3文件被存储在40个区块中。

#### GridFS操作文件
```js
/* 查询所有文件存储块 */
/* 查询所有文件存储块 */
db.getCollection('fs.chunks').find({})

/* 查询所有文件元数据 */
db.getCollection('fs.files').find({})

db.fs.chunks.find({files_id:ObjectId("5b17866403b6c204b0337f27")})

db.fs.files.find({_id:ObjectId("5b17866403b6c204b0337f27")})

/* 删除文件存储块 */
db.fs.chunks.remove({files_id:ObjectId("5b17654c03b6c2233029dcc4")})

/* 删除文件元数据 */
db.fs.files.remove({_id:ObjectId("5b17654c03b6c2233029dcc4")})
```

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


## 数据库角色

针对Mongodb数据库中的各种角色进行说明

### 数据库访问

角色名称	拥有权限
read	允许读取指定数据库的角色
readWrite	允许读写指定数据库的角色

### 数据库管理

角色名称	拥有权限
dbAdmin	允许用户在指定数据库中执行管理函数，如索引创建、删除，查看统计或访问system.profile
userAdmin	允许管理当前数据库的用户，如创建用户、为用户授权
dbOwner	数据库拥有者(最高)，集合了dbAdmin/userAdmin/readWrite角色权限



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



## MongoDB脚本

### 常用命令
```js
/*查询id为5afb988c0db9852c36c4bbdb的 车禁相机抓拍照片*/
db.getCollection('fs.files').find({"_id" :ObjectId("5afb988c0db9852c36c4bbdb")})
```

、切换/创建数据库
`use yourDB;` 当创建一个集合(table)的时候会自动创建当前数据库

查询所有数据库
`show dbs;`

删除当前使用数据库
`db.dropDatabase();`


查看当前使用的数据库
`db.getName();`

`db`和`db.getName()`方法是一样的效果，都可以查询当前使用的数据库

显示当前db状态
`db.stats();`

当前db版本
`db.version();`

查看当前db的链接机器地址
`db.getMongo();`

### 用户相关

1、添加一个用户
`db.addUser("name");`
 添加用户、设置密码、是否只读
`db.addUser("userName", "pwd123", true); `


2、显示当前所有用户
`show users;`

3、删除用户
`db.removeUser("userName");`


### 验证方式SCRAM-SHA-1调整为MONGODB-CR
首先关闭认证，修改system.version文档里面的authSchema版本为3，初始安装时候应该是5，命令行如下： 
```js
use admin;

var schema = db.system.version.findOne({"_id":"authSchema"})
schema.currentVersion = 3 

db.system.version.save(schema)

db.system.users.remove({}) //删除所有用户
```
Now restart the mongod and create new user then it should work fine.
然后重新创建普通用户 smalink

重新连接即可
