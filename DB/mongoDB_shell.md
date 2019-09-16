
[TOC]
# MongoDB脚本(shell)


## 脚本一般会用来执行以下任务
备份；
调度map-reduce命令； 
离线报告，离线任务； 
管理员定时任务；

## MongoDB操作文档对象


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

/* 删除文件存储块 */
db.fs.chunks.remove({files_id:ObjectId("5b17654c03b6c2233029dcc4")})

/* 删除文件元数据 */
db.fs.files.remove({_id:ObjectId("5b17654c03b6c2233029dcc4")})
```


## 访问控制

### windows版本下验证方式SCRAM-SHA-1
命令行如下： 
```js
use admin;

db.system.version.save(schema)

db.system.users.remove({}) //删除所有用户

/*添加管理员用户*/
db.createUser({user:"admin",pwd:"123456",roles:["root"]})

use smalink
/*smalink用户*/
db.createUser({user: "smalink", pwd: "smalink", roles: ["readWrite", "dbAdmin"]})
```
Now restart the mongod and create new user then it should work fine.
然后重新创建普通用户 smalink

重新连接即可


### MongoDB给数据库创建用户

#### 先以非授权的模式启动MongoDB
非授权：

linux/Mac : `mongod -f /mongodb/etc/mongo.conf`

windows  : `mongod --config d:\mongodb\mongo.config ` 或者  net start mongodb （前提是mongo安装到了服务里面）

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

use smalink
/*smalink用户*/
db.createUser({user: "smalink", pwd: "smalink", roles: ["readWrite", "dbAdmin"]})

3.通过客户端连接test数据库


## 业务脚本

### 切换/创建数据库
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


#### 用户相关

1、添加一个用户
`db.addUser("name");`
 添加用户、设置密码、是否只读
`db.addUser("userName", "pwd123", true); `


2、显示当前所有用户
`show users;`

3、删除用户
`db.removeUser("userName");`


### 常用查询语句介绍

1.insert 插入记录

db.person.insert({name:"ken",age:10})


2.update  更新记录

db.person.update({name:"ken"},{age:20})//更新name为ken的age为20，第一个对象参数即为查询条件，修改name为ken的项目的age为20.

db.person.update({"name":"ken"},{"age":20},true) //在后面多了一个true，表示upsert操作，即如果查询不到，则添加

//局部更新

$inc 和 $set

db.person.update({"name":"ken"},{$inc:{"age":10}})//如果原来的age为20，则更新后为30


3.find 查找

```js
/*查询id为5afb988c0db9852c36c4bbdb的 车禁相机抓拍照片*/
db.getCollection('fs.files').find({"_id" :ObjectId("5afb988c0db9852c36c4bbdb")})
```

4.remove  删除记录

 
5.count 计数


### 分页

#### 传统分页思路
假设一页大小为10条。则
```js
//page 1
1-10

//page 2
11-20

//page 3
21-30
...

//page n
10*(n-1) +1 - 10*n
```
MongoDB提供了skip()和limit()方法。

skip: 跳过指定数量的数据. 可以用来跳过当前页之前的数据，即跳过`pageSize*(n-1)`。
limit: 指定从MongoDB中读取的记录条数，可以当做页面大小pageSize。

##### 问题

看起来，分页已经实现了，但是官方文档并不推荐，说会扫描全部文档，然后再返回结果。
>The cursor.skip() method requires the server to scan from the beginning of the input results set before beginning to return results. As the offset increases, cursor.skip() will become slower.

所以，需要一种更快的方式。其实和mysql数量大之后不推荐用limit m,n一样，解决方案是先查出当前页的第一条，然后顺序数pageSize条。MongoDB官方也是这样推荐的。


#### 正确的分页办法
我们假设基于_id的条件进行查询比较。事实上，这个比较的基准字段可以是任何你想要的有序的字段，比如时间戳。
```js
//Page 1
db.users.find().limit(pageSize);
//Find the id of the last document in this page
last_id = ...
 
//Page 2
users = db.users.find({
  '_id' :{ "$gt" :ObjectId("5b16c194666cd10add402c87")}
}).limit(10)
//Update the last id with the id of the last document in this page
last_id = ...
```
显然，第一页和后面的不同。对于构建分页API, 我们可以要求用户必须传递pageSize, lastId。
pageSize 页面大小
lastId 上一页的最后一条记录的id，如果不传，则将强制为第一页




### update函数
      // query    查询条件  指明要更新的文档  相当于SQL中的where语句
      // obj      更改的内容  更改的内容  相当于SQL中的set语句
      // upsert   当查询条件query指明的文档不存在时，是否需要插入一条新文档 {upsert:true}
      // multi    当查询条件query返回多个文档时，是否需要一次更新所有满足条件的文档 {multi:true}
   
      更新多个文档 第四个参数  设为true 会更新所有匹配的文档(添加键值gift:"happyBIrthday" 不设为true 只更新匹配的第一条)
      db.user.update({birthday:"02/02/2008"},{$set:{gift:"happyBIrthday"}},false,true)


### 更新操作符(update operators)
      更新操作是原子性
      
      在执行修改语句前 对变量的操作不会修改数据库
      使用修改器时,"_id"的值不能改变(整个文档改变时是可以改变"_id"的值得)
      
      $inc
         更新修改器是特殊的键  
         用来增加已有键的值,或者在键不存在的时候创建一个键
         对于分析数据,因果关系.投票或者其他有变化数值的地方
         下面是更新文档中某个键的值  使其结果加1
      
         db.user.insert({url:"www.example.com",pageviews:52})
         db.user.update({url:"www.example.com"},{$inc:{pageviews:1}})    结果 pageviews=53要是想加多改变 1 的值就好
      
      $set
         用来指定一个键的值.如果这个键不存在,则创建它 存在将其值修改  还可以修改数据类型,内嵌文档
         
         db.user.update({username:"joe"}, {$set:{"favorite book":["green eggs and ham","guzhuang","yanqing"]}})  可以变成数组
      
      $unset  
         将键完全删除 
         
         db.user.update({username:"joe"},{$unset:{"favoeite book":1}})
         增加,修改或删除键的时候,应该使用$修改器.一定要使用以$开头的修改器来修改键/值对
      
      $inc 与 $set的用法类似,就是专门来增加(减少)数字的.$inc只能用于键的值是数字

      $upsert  
         值为true 
         db.blog.update({url:"/log"},{$inc:{visits:1}},true) 有就更新+1 没有创建 不会在查询回来再判断


### 数组元素
      $push           
         如果指定的键已经存在,$push会向已有的的元素的末尾追加一个元素,要是没有就会创建一个新的数组
         db.blog.posts({title:"a blog post"},{$push:{comments:{name:"joe",email:"999@.com",content:"nice post"}}})
                  会向文档中添加一个数组comments 如果在在此基础上运行此修改语句会在数组的后面追加新 

      $addToSet
         如果一个值不在数组中 可以用$ne $addToSet把他加进去  addToSet可以避免重复
         
      $addToSet
         与  $each 组合 可以添加不同的多个值
         
      $pop 
         若是把数组看成是队列或栈 可以用$pop 从数组的任意一端删除元素{$pop:{key:1}}删除末尾元素{$pop:{key:-1}}删除头部元素
      
         
      $pull  
         会将所有匹配的部分删除如 update({},{pull:{name:"zhangsan"}})


### 修改器的速度
      $inc 运行速度比较快 能就地的修改.因为不需要改变文档的大小 只需要将键的值改变
      而数组修改器可能会改变文档的大小,就会慢一些 ($set能在文档大小不发生变化时立即修改,否则性能也会下降)

## 查询
### find
      find({name:"zhangsan"},{_id:0,username:1}) 第一个参数查询条件  第二个参数是过滤是否返回的列  0 不返回 1返回
      查询条件 $lt(<) $lte(<=) $gt(>) $get(>=) $ne(!=)
      
      $in  用来查询一个键的多个值  与之相反的事$nin
      
      $or  用来查询多个键的任意给定值
      
      两者连用 ticket_no与三个值匹配 外加 winner键
      db.user.find({$or:[{ticket_no}:{$in:[725,21,098]},]},{winner:true})
      
      $not  元条件句  $mod {$mod:[5,1]}
      
      null  null 不仅匹配自身  而且匹配不存在的   所以还会匹配缺少这个键的所有文档
            如果仅仅匹配键值为null 的文档  要通过$exists 来判断   键值已经存在
            db.user.find(name:{$in:[null],$exists:true})
### 查询数组
         
      $all 通过多个元素匹配数组 用$all就会匹配一组元素  要找到所有文档中fruit数组中既有  banana  又有apple的数组 
      
      要想查询数组指定位置的元素 则需要使用key.index语法   如db.food.find(fruit.2:"apple") 查找水果 的下标为2及第三个元素是 "apple"
      
      $size  查询指定长度的数组
      
      limit(条数) skip(条数) sort({price:-1(1)})
         分页 db.stock.find({name:"mp3"}).limit(5).skip(5).sort(price:1) 每次返回limit 每次跳过skip  排序 sort (1升序,-1降序)
         
         不建议使用skip做分页 因为skip略过太多的数据 影响效率
         分页如下
         var page1 = db.foo.find().sort({data:-1)).limit(100)  
         利用最后一个文档的排序条件作为查询条件来查询下一条记录
         var latest = null;
         //display first page 
         while(page1.hasNext()){
            latest = page1.next();
            display(latest);
         }
         //get next page 
         var page2= db.foo.find({"data"}:{$gt:latest.data});
         page2.sort({data:-1}).limit(100);


