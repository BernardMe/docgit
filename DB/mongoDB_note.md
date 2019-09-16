
# MongoDB
	
	什么是文档:多个键及其关联的值有序的放置在一起便是文档
	1.文档是MongoDB的基本单元,核心概念  类似于关系型数据库的行
	2.每一个文档都有一个特殊的键"_id",它在文档所在的集合中是唯一的
	3.MongoDB不但区分类型还区分大小写 文档不能有重复的键
  
## 集合
    集合就是一组文档  相当于关系型数据库里的表
	集合是无模式的  一个集合里的文档可以是各式各样的 如下
		{"key1":"Hello word"}
		{"key2":5}
	上面两个文档的数据类型不同.键也不一样,因为集合里可以放置任意类型的文档
	集合的命名  
		不能是""空串  
		不能含有\0字符,这个字符表示集合名的结尾 ,
		结合不能以system.开头 这是为系统集合保留的前缀
		用户创建的集合的名字不能包含保留字$
	子集合
		组织集合的一种惯例是使用"."字符分开的按命名空间的划分的子集合.如
			person.detail与person.address  这样的目的只是使组织结构更好些 也就是说 person这个集合(这里根本不需要存在)及其子集合根本没有任何关系
			GridFS是一种存储大文本的协议,使用子集合来存储文件的元数据  这样就与内容快分开了
	MongoDB的客户端shell
		db是MongoDB的全局变量 db 保存的是客户端与服务器数据库的连接 这个变量是通过shell访问MongoDB的主要入口点

	ObjectID组成
		`_id` 是mongodb ObjectID类型的，它由12位结构组成，包括timestamp, machined, processid, counter 等。

		TimeStamp
		前 4字节是一个unix的时间戳，是一个int类别，我们将上面的例子中的objectid的前4位进行提取“4df2dcec”，然后再将他们安装十六进制 专为十进制：“1307761900”，这个数字就是一个时间戳，为了让效果更佳明显，我们将这个时间戳转换成我们习惯的时间格式
		`$ date -d ‘1970-01-01 UTC 1307761900  sec’  -u`
		2011年 06月 11日 星期六 03:11:40 UTC
		前 4个字节其实隐藏了文档创建的时间，并且时间戳处在于字符的最前面，这就意味着ObjectId大致会按照插入进行排序，这对于某些方面起到很大作用，如 作为索引提高搜索效率等等。使用时间戳还有一个好处是，某些客户端驱动可以通过ObjectId解析出该记录是何时插入的，这也解答了我们平时快速连续创 建多个Objectid时，会发现前几位数字很少发现变化的现实，因为使用的是当前时间，很多用户担心要对服务器进行时间同步，其实这个时间戳的真实值并 不重要，只要其总不停增加就好。
		比如`"_id" : ObjectId("5b1886f8965c44c78540a4fc")`
		取id的前4个字节。由于id是16进制的string，4个字节就是32位，对应id前8个字符。即5b1886f8, 转换成10进制为1528334072. 加上1970，就是当前时间。

		Machine
		接下来的三个字节，就是 2cdcd2 ,这三个字节是所在主机的唯一标识符，一般是机器主机名的散列值，这样就确保了不同主机生成不同的机器hash值，确保在分布式中不造成冲突，这也就是在同一台机器生成的objectid中间的字符串都是一模一样的原因。

		pid
		上面的Machine是为了确保在不同机器产生的objectid不冲突，而pid就是为了在同一台机器不同的mongodb进程产生了objectid不冲突，接下来的0936两字节就是产生objectid的进程标识符。

		increment
		前面的九个字节是保证了一秒内不同机器不同进程生成objectid不冲突，这后面的三个字节a8b817，是一个自动增加的计数器，用来确保在同一秒内产生的objectid也不会发现冲突，允许256的3次方等于16777216条记录的唯一性。

##  Mongodb数据库中的各种角色

	数据库访问
		角色名称	拥有权限
		read		允许读取指定数据库的角色
		readWrite	允许读写指定数据库的角色

	数据库管理
		角色名称	拥有权限
		dbAdmin		允许用户在指定数据库中执行管理函数，如索引创建、删除，查看统计或访问system.profile
		userAdmin	允许管理当前数据库的用户，如创建用户、为用户授权
		dbOwner		数据库拥有者(最高)，集合了dbAdmin/userAdmin/readWrite角色权限

# MongoDB的插入
	db.user.insert({username:"yxw",password:"123456"})
	

# MongoDB的删除
	db.user.remove()--->删除集合中的所有数据 不删除集合本身和原有的索引
	db.user.remove({username:"yxw"}) 只删除符合条件的数据
	db.drop_collection("user1")

	
# MongoDB文档修改
	
## update函数
		// query    查询条件  指明要更新的文档  相当于SQL中的where语句
		// obj      更改的内容  更改的内容  相当于SQL中的set语句
		// upsert   当查询条件query指明的文档不存在时，是否需要插入一条新文档 {upsert:true}
		// multi    当查询条件query返回多个文档时，是否需要一次更新所有满足条件的文档 {multi:true}
	
		更新多个文档 第四个参数  设为true 会更新所有匹配的文档(添加键值gift:"happyBIrthday" 不设为true 只更新匹配的第一条)
		db.user.update({birthday:"02/02/2008"},{$set:{gift:"happyBIrthday"}},false,true)


## 更新操作符(update operators)
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


## 数组元素
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


## 修改器的速度
		$inc 运行速度比较快 能就地的修改.因为不需要改变文档的大小 只需要将键的值改变
		而数组修改器可能会改变文档的大小,就会慢一些 ($set能在文档大小不发生变化时立即修改,否则性能也会下降)

# 查询
## find
		find({name:"zhangsan"},{_id:0,username:1}) 第一个参数查询条件  第二个参数是过滤是否返回的列  0 不返回 1返回
		查询条件 $lt(<) $lte(<=) $gt(>) $get(>=) $ne(!=)
		
		$in  用来查询一个键的多个值  与之相反的事$nin
		
		$or  用来查询多个键的任意给定值
		
		两者连用 ticket_no与三个值匹配 外加 winner键
		db.user.find({$or:[{ticket_no}:{$in:[725,21,098]},]},{winner:true})
		
		$not  元条件句  $mod {$mod:[5,1]}
		
		null  null 不仅匹配自身  而且匹配不存在的	所以还会匹配缺少这个键的所有文档
				如果仅仅匹配键值为null 的文档  要通过$exists 来判断	键值已经存在
				db.user.find(name:{$in:[null],$exists:true})
## 查询数组
			
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
	
# 索引

# 集群	
	主从  主库  写  丛库(备份主库数据) 只读  主库丛库物理分隔
	搭建高可用MongoDB集群
	
	
	
	
	