

## 3NF(范式)

### 1NF
即表的列具有原子性，不可再分解。
数据库是关系型数据库，就自动满足1NF

### 2NF
表中的记录是唯一的，就满足2NF，通常我们设计一个主键来实现

### 3NF
- 确保数据表中的每一列数据都和主键直接相关，而不能间接相关
- 属性不依赖于其他非主属性

### 范式的优缺点
- 优点
  + 结构合理
  + 冗余较小
  + 尽量避免插入删除修改异常
- 缺点
  + 性能降低(多表查询比单表查询速度慢)


## MySQL创建用户


## MySQL数值类型
TINYINT: 1个字节
SMALLINT: 2个字节
INT：4个字节
INTEGER：INT的同义词
BIGINT：8个字节

FLOAT：4个字节
DOUBLE：8个字节

## MySQL字符串(字符)类型
CHAR：固定长度字符串 sex char(2)
VARCHAR: 可变长度字符串 name varchar(20)
VARCHARA使用起来较为灵活，CHAR处理速度更快

TEXT：非二进制大对象(字符)
BLOB：二进制大对象(非字符)

## mysql中int、bigint、smallint 和 tinyint的区别与长度
1、在mysql 命令行创建如下表


CREATE TABLE `test_int_1` (
  `int_id` int NOT NULL,
  `bigint_id` bigint DEFAULT NULL,
  `bigint_25` bigint(25) DEFAULT NULL,
  `bigint_18` bigint(18) DEFAULT NULL,
  `int_8` int(8) DEFAULT NULL,
  `int_3` int(3) DEFAULT NULL,
  `smallint_id` smallint DEFAULT NULL,
  `tinyint_id` tinyint DEFAULT NULL,
  PRIMARY KEY (`int_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8

2、desc


mysql> desc test_int_1;
+-------------+-------------+------+-----+---------+-------+
| Field       | Type        | Null | Key | Default | Extra |
+-------------+-------------+------+-----+---------+-------+
| int_id      | int(11)     | NO   | PRI | NULL    |       |
| bigint_id   | bigint(20)  | YES  |     | NULL    |       |
| bigint_25   | bigint(25)  | YES  |     | NULL    |       |
| bigint_18   | bigint(18)  | YES  |     | NULL    |       |
| int_8       | int(8)      | YES  |     | NULL    |       |
| int_3       | int(3)      | YES  |     | NULL    |       |
| smallint_id | smallint(6) | YES  |     | NULL    |       |
| tinyint_id  | tinyint(4)  | YES  |     | NULL    |       |
+-------------+-------------+------+-----+---------+-------+
8 rows in set (0.00 sec)
对比发现 int bigint smallint 和 tinyint 类型，如果创建新表时没有指定 int(M) 中的M时，默认分别是 ：

int             -------     int(11)

bigint       -------     bigint(20)

smallint   -------     smallint(6)

tinyint     -------     tinyint(4)

MySQL还支持选择在该类型关键字后面的括号内指定整数值的显示宽度(例如，INT(4))。`int(M) 在 integer 数据类型中，M 表示最大显示宽度`，该可选显示宽度规定用于显示宽度小于指定的列宽度的值时从左侧填满宽度。

显示宽度并不限制可以在列内保存的值的范围，也不限制超过列的指定宽度的值的显示。

在 int(M) 中，M 的值跟 int(M) 所占多少存储空间并无任何关系。和数字位数也无关系， int(3)、int(4)、

int(8) 在磁盘上都是占用 4 btyes 的存储空间。

## 查询MySQL字符集相关参数
show variables like '%character%';

## MySQL字符序
show variables like '%collation%';
mysql的collation大致的意思就是字符序。首先字符本来是不分大小的，那么对字符的>, = , < 操作就需要有个字符序的规则。collation做的就是这个事情，你可以对表进行字符序的设置，也可以单独对某个字段进行字符序的设置。一个字符类型，它的字符序有多个

## 连接字符串是否设置了编码
如
jdbc:mysql://192.168.1.211:3306/xxx?useUnicode=true&characterEncoding=utf-8

## MySQL汉字乱码问题
新产品开发，有时候需要迁移历史数据，而且往往还是异构系统的数据。
这时候常常会遇到乱码的问题，原因主要是因为字符集不匹配引起的。
对于MySQL而言，存在`客户端字符集、服务器字符集、数据库字符集以及连接字符集`等变量，

如果你不希望服务器做任何的结果转换，那么可以把character_set_results设置为NULL:
```shell
SET character_set_results = NULL;
SET character_set_client = utf8;
SET character_set_server = utf8;
SET character_set_database = utf8;
SET character_set_connection = utf8;
```
(如上)


## INSERT into 语句不支持表别名


## MySQL实现序列(Sequence)效果

一般使用序列(Sequence)来处理主键字段，在mysql中是没有序列的，但是MySQL有提供了自增长(increment)来实现类似的目的，但也只是自增，而不能设置步长、开始索引、是否循环等，最重要的是一张表只能由一个字段使用自增，但有的时候我们需要两个或两个以上的字段实现自增（单表多字段自增），MySQL本身是实现不了的，但我们可以用创建一个序列表，使用函数来获取序列的值

### 创建序列表
```sql
-- MySQL创建序列(没有sequence对象，需要借助序列表)
drop table if exists sequence;
CREATE TABLE sequence (
  seq_name VARCHAR(50) not null, -- 序列名称
  current_value INT not null, -- 当前值
  increment_val INT not null DEFAULT 1, -- 步长为1
  PRIMARY KEY(seq_name)
);
```
### 新增序列
```sql  
-- 新增3个序列
INSERT INTO sequence VALUES ('seq_test1_num1', '0', '1');
INSERT INTO sequence VALUES ('seq_test1_num2', '0', '2');
INSERT INTO sequence VALUES ('seq_employee_num1', '0', '1');
```
### 创建函数 
```sql
-- 创建函数用于获取序列当前值(v_seq_name 参数名 代表序列名称)
CREATE FUNCTION currval(v_seq_name VARCHAR(50))
RETURNS INTEGER
BEGIN
  DECLARE val integer;
  SET val = 0;
  SELECT current_value INTO val FROM sequence where seq_name = v_seq_name;
  RETURN val;
END
```
### 查询当前值
```sql
SELECT currval('seq_test1_num1');
```
### 创建函数用于获取序列下一个值
```sql
-- 创建函数用于获取序列下一个值(v_seq_name 参数名 代表序列名称)
CREATE FUNCTION nextval(v_seq_name varchar(50))
RETURNS INTEGER
BEGIN
  UPDATE sequence SET current_value = current_value + increment_val 
    WHERE seq_name = v_seq_name;
  RETURN currval(v_seq_name);
END
```
### 查询下一个值
```sql
SELECT nextval('seq_employee_num1');
```
### 新建触发器
```sql
-- 新建触发器 插入新纪录前给自增字段赋值实现字段自增效果
CREATE TRIGGER TRI_employee_num_1 before INSERT ON employee for EACH ROW 
BEGIN
  SET NEW.e_no = nextval('seq_employee_num1');
END

-- 最后测试自增效果
INSERT INTO employee VALUES (currval('seq_employee_num1'), '李四', 24, 1200.00, '东三旗', 20);

```

## 创建表技巧

### 存在则删除
```sql
DROP TABLE IF EXISTS demo1;
```

## MySQL中的分区
MySQL从5.1开始支持分区功能。分区一句话就是：把一张表按照某种规则（range/list/hash/key等）分成多个区域（页/文件）保存。对mysql应用开发来说，分区与不分区是没区别的（即对应用是透明的）。如同突围战中的“化整为零”。MySQL支持大部分的存储引擎（如：MyISAM、InnoDB、Memory等）创建分区，不支持MERGE和CSV来创建分区。同一个分区表中的所有分区必须是同一个存储引擎。

###　分区作用
可以存储更多的数据（系统单个文件最大限制） 优化查询，在where子句中，如果包含分区条件，只需要扫描一个或部分分区来提高查询效率。在涉及sum()这类函数时候， 可以在分区上并行处理，最后汇总结果。 对于过期或不需要的数据，可以删除相关分区来快速删除数据。 跨多个磁盘来分散数据查询，单表的并发能力提高了，磁盘I/O性能也提高了。

### [Mysql]——通过例子理解事务的4种隔离级别
第1级别：Read Uncommitted(读取未提交内容)
第2级别：Read Committed(读取提交内容)
第3级别：Repeatable Read(可重读)
第4级别：Serializable(可串行化)

SQL标准定义了4种隔离级别，包括了一些具体规则，用来限定事务内外的哪些改变是可见的，哪些是不可见的。

低级别的隔离级一般支持更高的并发处理，并拥有更低的系统开销。

#### 脏读
脏读就是指当一个事务正在访问数据，并且对数据进行了修改，而这种修改还没有提交到数据库中，这时，另外一个事务也访问这个数据，然后使用了这个数据。

#### 不可重复读
是指在一个事务内，多次读同一数据。在这个事务还没有结束时，另外一个事务也访问该同一数据。那么，在第一个事务中的两 次读数据之间，由于第二个事务的修改，那么第一个事务两次读到的的数据可能是不一样的。这样就发生了在一个事务内两次读到的数据是不一样的，因此称为是不 可重复读。例如，一个编辑人员两次读取同一文档，但在两次读取之间，作者重写了该文档。当编辑人员第二次读取文档时，文档已更改。原始读取不可重复。如果 只有在作者全部完成编写后编辑人员才可以读取文档，则可以避免该问题。

#### 幻读
是指当事务不是独立执行时发生的一种现象，例如第一个事务对一个表中的数据进行了修改，这种修改涉及到表中的全部数据行。 同时，第二个事务也修改这个表中的数据，这种修改是向表中插入一行新数据。那么，以后就会发生操作第一个事务的用户发现表中还有没有修改的数据行，就好象 发生了幻觉一样。例如，一个编辑人员更改作者提交的文档，但当生产部门将其更改内容合并到该文档的主复本时，发现作者已将未编辑的新材料添加到该文档中。 如果在编辑人员和生产部门完成对原始文档的处理之前，任何人都不能将新材料添加到文档中，则可以避免该问题。

v:可能出现  x:不可出现

|      隔离级别     | 脏读  | 不可重复读 | 幻读 | 备注
|                -- |  --   |    --    | --   | --
|Read Uncommitted   |   v   |    v      |   v |( 隔离级别最低，并发性能高 )
|Read Committed     |   x   |    v      |   v |（锁定正在读取的行）
|Repeatable Read    |   x   |    x      |   v |（锁定所读取的所有行）
|Serializable       |   x   |    x      |   x |（锁表）

不可重复读的重点是`修改` : 
同样的条件 ,   你读取过的数据 ,   再次读取出来发现值不一样了 

幻读的重点在于`新增或者删除` 
同样的条件 ,   第 1 次和第 2 次读出来的记录数不一样

#### Spring在TransactionDefinition接口中定义这些属性

在TransactionDefinition接口中定义了五个不同的事务隔离级别

ISOLATION_DEFAULT 这是一个PlatfromTransactionManager默认的隔离级别，使用数据库默认的事务隔离级别.另外四个与JDBC的隔离级别相对应 
ISOLATION_READ_UNCOMMITTED 这是事务最低的隔离级别，它充许别外一个事务可以看到这个事务未提交的数据。这种隔离级别会产生脏读，不可重复读和幻像读

ISOLATION_READ_COMMITTED 保证一个事务修改的数据提交后才能被另外一个事务读取。另外一个事务不能读取该事务未提交的数据。这种事务隔离级别可以避免脏读出现，但是可能会出现不可重复读和幻像读。

ISOLATION_REPEATABLE_READ 这种事务隔离级别可以防止脏读，不可重复读。但是可能出现幻像读。它除了保证一个事务不能读取另一个事务未提交的数据外，还保证了避免下面的情况产生(不可重复读)。

ISOLATION_SERIALIZABLE 这是花费最高代价但是最可靠的事务隔离级别。事务被处理为顺序执行。除了防止脏读，不可重复读外，还避免了幻像读。

## 事务

### 事务传播行为
3.1 当一个具有事务控制的方法被另一个有事务控制的方法调用后,需要如何管理事务(新建事务?在事务中执行?把事务挂起?报异常?)
3.2 REQUIRED (默认值): 如果当前有事务,就在事务中执行,如果当前没有事务,新建一个事务.
3.3 SUPPORTS:如果当前有事务就在事务中执行,如果当前没有事务,就在非事务状态下执行.
3.4 MANDATORY:必须在事务内部执行,如果当前有事务,就在事务中执行,如果没有事务,报错.
3.5 REQUIRES_NEW:必须在事务中执行,如果当前没有事务,新建事务,如果当前有事务,把当前事务挂起.
3.6 NOT_SUPPORTED:必须在非事务下执行,如果当前没有事务,正常执行,如果当前有事务,把当前事务挂起.
3.7 NEVER:必须在非事务状态下执行,如果当前没有事务,正常执行,如果当前有事务,报错.
3.8 NESTED:必须在事务状态下执行.如果没有事务,新建事务,如果当前有事务,创建一个嵌套事务






