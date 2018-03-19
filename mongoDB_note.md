

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



