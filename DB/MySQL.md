




## MySQL原理

### join 算法原理

MySQL(<=8.0)目前只有一种JOIN 算法，就是NESTED-LOOP JOIN算法, 不支持HASH JOIN算法

理论上，
Simple Nested-Loop Join（简单的嵌套循环连接）
简单来说嵌套循环连接算法就是一个双层for 循环 ，通过循环外层表的行数据，逐个与内层表的所有行数据进行比较来获取结果，当执行select * from user tb1 left join level tb2 on tb1.id=tb2.user_id

Nested-Loop Join 简单粗暴容易理解，就是通过双层循环比较数据来获得结果，但是这种算法显然太过于粗鲁，如果每个表有1万条数据，那么对数据比较的次数=1万 * 1万 =1亿次，很显然这种查询效率会非常慢。


实际上，
MySQL会随机应变
肯定不会这么粗暴的去进行表的连接，所以就出现了后面的两种对Nested-Loop Join 优化算法，在执行join 查询时mysql 会根据情况选择 后面的两种优join优化算法的一种进行join查询。

Index Nested-Loop Join（索引嵌套循环连接）

Index Nested-Loop Join其优化的思路 主要是为了减少内层表数据的匹配次数， 简单来说Index Nested-Loop Join 就是通过外层表匹配条件 直接与内层表索引进行匹配，避免和内层表的每条记录去进行比较， 这样极大的减少了对内层表的匹配次数，从原来的匹配次数=外层表行数 * 内层表行数,变成了 外层表的行数 * 内层表索引的高度，极大的提升了 join的性能

注意：使用Index Nested-Loop Join 算法的前提是匹配的字段必须建立了索引。

Block Nested-Loop Join（缓存块嵌套循环连接）

Block Nested-Loop Join 其优化思路是减少外层表的循环次数，Block Nested-Loop Join 通过一次性缓存多条数据，把参与查询的列缓存到join buffer 里，,然后拿join buffer里的数据批量与内层表的数据进行匹配，从而减少了外层循环的次数，当我们不使用Index Nested-Loop Join的时候，默认使用的是Block Nested-Loop Join。

注意：
1、使用Block Nested-Loop Join 算法需要开启优化器管理配置的optimizer_switch的设置block_nested_loop为on 默认为开启，如果关闭则使用Simple Nested-Loop Join 算法；
通过指令：Show variables like 'optimizer_switc%'; 查看配置
2、设置join buffer 的大小
通过join_buffer_size参数可设置join buffer的大小
指令：Show variables like 'join_buffer_size%';


## mysql常用命令查看数据库、表、字段编码

 1.查看数据库支持的所有字符集 
        show character set;或show char set;  

  2.查看当前状态 里面包括当然的字符集设置 
        status或者\s 

  3.查看系统字符集设置，包括所有的字符集设置 
        show variables like 'char%'; 

  4.查看数据表中字符集设置 
        show full columns from tablename; 或者 show create table tablename\G; 

  5.查看数据库编码 
        show create database dnname;  



## MySQL5.7(windows)解压版如何安装

### 配置

2.1 下载下来的zip后缀的程序包，解压出来，然后自定义名称放在相应的位置上，我是在服务器的D盘根目录下，命名为：mysql-5.7，即D:\mysql-5.7\ ，该目录下包含bin、data、docs、lib等目录及文件；
 
2.2 配置环境变量，在系统变量path的末尾加入：;D:\mysql-5.7\bin (注意是追加，不是覆盖)
 
2.3 配置my.ini
复制程序目录下的文件my-default.ini 为my.ini，并且编辑里面的内容为：

```
#代码开始
[Client]
#设置3306端口
port = 3306
 
[mysqld]
#设置3306端口
port = 3306
# 设置mysql的安装目录
basedir=D:\mysql_5_7
# 设置mysql数据库的数据的存放目录
datadir=D:\mysql_5_7\data
# 允许最大连接数
max_connections=200
# 服务端使用的字符集默认为8比特编码的latin1字符集
character-set-server=utf8
# 创建新表时将使用的默认存储引擎
default-storage-engine=INNODB
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
 
[mysql]
# 设置mysql客户端默认字符集
default-character-set=utf8
#代码结束
```

 
### 5.7安装
以管理员身份运行开始－运行－输入cmd，进入DOS窗口后，首先切换到MYSQL的程序目录：

`mysqld  install mysql_5_7`（mysqld -remove 表示删除mysql）

Service successfully installed.(说明安装成功了)
 
#### 初始化创建用户
在初始化时 `mysqld --initialize-insecure --user=root`，则会创建空密码的 root@localhost 账号,
否则会创建带密码的root@localhost账户，密码直接写在log-error日志文件中；
新用户登录后必须立刻更改密码，否则无法继续后续的工作。

D:\mysql-5.7\bin>net start mysql
MySQL 服务正在启动 ..
MySQL 服务已经启动成功。（说明服务启动成功了）

`select version();` 或者 `status`
查看MySQL服务器版本

#### 修改root用户密码
登录后,
`SET PASSWORD FOR 'root'@'localhost' = PASSWORD('root');`


### Linux下服务未启动问题Unit mysqld.service not loaded
检查mysql服务状态
`/etc/init.d/mysql status`
返回`ERROR! MySQL is not running, but PID file exists`,可见服务没启动

启动mysql服务
`/etc/init.d/mysql start`
返回`Starting MySQL SUCCESS! `服务启动了


### 授权指定用户通过用户名密码远程连接数据库
`grant all on *.* to root@'%' identified by '123456';`

`grant all on eface0420.* to smartlink@'%' identified by 'slink'`
本質上會在mysql實例中db表中插入相應的授权记录

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

## 创建数据库
```sql
CREATE DATABASE  IF NOT EXISTS `db_library` DEFAULT CHARACTER SET utf8 ;
```

## mysql中int、bigint、smallint 和 tinyint的区别与长度
1、在mysql 命令行创建如下表

```sql
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
```

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


## MySQL数值类型
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


##　SQL truncate 、delete与drop区别

### 相同点：
1.truncate和不带where子句的delete、以及drop都会删除表内的数据。
2.drop、truncate都是DDL语句(数据定义语言),执行后会自动提交。

### 不同点：
1. truncate 和 delete 只删除数据不删除表的结构(定义)
drop 语句将删除表的结构被依赖的约束(constrain)、触发器(trigger)、索引(index)；依赖于该表的存储过程/函数将保留,但是变为 invalid 状态。

2. delete 语句是数据库操作语言(dml)，这个操作会放到 rollback segement 中，事务提交之后才生效；如果有相应的 trigger，执行的时候将被触发。
truncate、drop 是数据库定义语言(ddl)，操作立即生效，原数据不放到 rollback segment 中，不能回滚，操作不触发 trigger。

3.速度，一般来说: drop> truncate > delete

4.安全性：小心使用 drop 和 truncate，尤其没有备份的时候.否则哭都来不及
使用上,想删除部分数据行用 delete，注意带上where子句. 回滚段要足够大.
想删除表,当然用 drop
想保留表而将所有数据删除，如果和事务无关，用truncate即可。如果和事务有关,或者想触发trigger,还是用delete。
如果是整理表内部的碎片，可以用truncate跟上reuse stroage，再重新导入/插入数据。


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

## MySQL自增

### MySQL自增ID起始值修改方法

并且该语句也适用于改动现有表的id上。
比如大批量删除数据后，想 id 从 654321 退回 123456 开始
```sql
-- id从123456 开始
alter table users AUTO_INCREMENT=123456;
```


## MySQL原生函数

### mysql插入当前日期now()

特殊情况下
用current_timestamp，不过这个默认值只用在timestamp的列，对datetime列无效
```sql
create table default_time (
  id int not null primary key auto_increment,
  name varchar(20) default 'chenlb',
  my_time timestamp default current_timestamp
);
```
注意：一个表只能有一个timestamp列的默认值为当前日期时间


一般情况下
数据库应该有一个表项addtime 类型为datetime 输入的时候sql语句类似
insert into tablename （“a”，“addtime”）value （“Haha”，NOW（））； 

### mysql表链接
mysql默认使用等值链接join  取得两个表中存在连接匹配关系的记录



## MySQL存储过程

### 什么是mysql存储例程? 
存储例程是存储在数据库服务器中的一组sql语句，通过在查询中调用一个指定的名称来执行这些sql语句命令.

### 为什么要使用mysql存储过程？ 
我们都知道应用程序分为两种，一种是基于web，一种是基于桌面，他们都和数据库进行交互来完成数据的存取工作。假设现在有一种应用程序包含了这两 种，现在要修改其中的一个查询sql语句，那么我们可能要同时修改他们中对应的查询sql语句，当我们的应用程序很庞大很复杂的时候问题就出现这，不易维 护！另外把sql查询语句放在我们的web程序或桌面中很容易遭到sql注入的破坏。而存储例程正好可以帮我们解决这些问题。 
存储过程(stored procedure)、存储例程(store routine)、存储函数区别 
Mysql存储例程实际包含了存储过程和存储函数，它们被统称为存储例程。 
其中存储过程主要完成在获取记录或插入记录或更新记录或删除记录，即完成select insert delete update等的工作。而存储函数只完成查询的工作，可接受输入参数并返回一个结果。

### 创建存储过程,存储函数
`create procedure 存储过程名(参数) `
存储过程体 
`create function 存储函数名(参数)`

在`命令列界面`，使用create关键字创建存储过程
注意：
（1）这里需要注意的是DELIMITER//和DELIMITER;两句，DELIMITER是分割符的意思，因为MySQL默认以”;”为分隔 符，如果我们没有声明分割符，那么编译器会把存储过程当成SQL语句进行处理，则存储过程的编译过程会报错，所以要事先用DELIMITER关键字申明当 前段分隔符，这样MySQL才会将”;”当做存储过程中的代码，不会执行这些代码，用完了之后要把分隔符还原
（2）存储过程根据需要可能会有输入、输出、输入输出参数，这里有一个输出参数s，类型是int型，如果有多个参数用”,”分割开。 
（3）过程体的开始与结束使用BEGIN与END进行标识。
```shell
mysql> delimiter //
mysql> CREATE PROCEDURE mytest()
    -> BEGIN
    -> declare i int; 
    -> DECLARE j int;
    -> set i = 2;
    -> while i < 11 do
    -> SET j=CONVERT(CONCAT('2',i), SIGNED); 
    -> INSERT INTO DEVICE_COMPARISION_INFO(`ID`, `DEVICE_ID`, `ALGORITHM_VERSION`, `MEMO`) 
    -> VALUES (i, j, NULL, NULL);
    -> set i=i+1;
    -> end while;
    -> end
    -> //
Query OK, 0 rows affected

mysql> delimiter;
```
在SQL查询界面使用call关键字调用该存储过程
```sql
call mytest();  -- 调用进程
```

存储过程中，声明varchar类型变量要带上(长度)
```shell
mysql> DELIMITER //
mysql> CREATE PROCEDURE mytest2()
    -> BEGIN
    -> declare i int;
    -> DECLARE j VARCHAR(20);
    -> DECLARE n VARCHAR(50);
    -> DECLARE p VARCHAR(20);
    -> DECLARE m VARCHAR(100);
    -> set i = 11;
    -> while i < 100 do
    -> SET j=CONCAT('考勤机22',i);
    -> SET n=CONCAT('8119617030',i);
    -> SET p=CONCAT('192.168.123.',i);
    -> SET m=CONCAT('00:11:7F:A6:E2:',i);
    -> INSERT INTO DEVICE_BASIC_INFO(`ID`,`LOCATION_ID`,`NAME`,`SN_CODE`,`UPDATE_TIME`,`CONNECTION_TIME`,`IS_USED`,`FIRMWARE`,`DEVICE_TYPE`,`CONNECTION_STATE`,`IP_ADDRESS`,`PORT`,`PWD`,`USED_AMOUNT`,`TOTAL_AMOUNT`,`USED_RECORD_AMOUNT`,`TOTAL_RECORD_AMOUNT`,`IS_USED_NORMAL`,`IS_RECORD_NORMAL`,`MAC_ADDRESS`,`MEMO`,`DEPARTMENT_ID`,`FACTORY`,`TYPE`,`USE_FOR`,`DOMAIN_ID`,`POSITION`)
    -> VALUES (null, 123, j, n,  '2018-03-05 10:24:14', '2018-03-05 10:27:14', 1, '2.340.260', 1, 0, p, null, null, 6, 1000,  35,  150000, null, null, m, null, 289, null, null, '11,12,13',  162, '320');
    -> set i=i+1;
    -> end while;
    -> end
    -> //
Query OK, 0 rows affected

mysql> delimiter;
```


## 创建表技巧

### 存在则删除
```sql
DROP TABLE IF EXISTS demo1;
```

## MySQL命令行导入导出

### 导出单个数据库
在cmd命令行窗口下:
`mysqldump -h 192.168.134.253 -uroot -p efacetest > f:\a.sql`
(如果没有错误，会提示你输入密码)

### 导入数据
也是直接在cmd命令行输入命令即可
`mysql -h 127.0.0.1 -uroot -p123456 efacetest < f:\a.sql`


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


### MySQL不同引擎




#### 脏读
脏读就是指当一个事务正在访问数据，并且对数据进行了修改，而这种修改还没有提交到数据库中，这时，另外一个事务也访问这个数据，然后使用了这个数据。

#### 不可重复读
是指在一个事务内，多次读同一数据。在这个事务还没有结束时，另外一个事务也访问该同一数据禁用外键约束：

SET FOREIGN_KEY_CHECKS=0;

启用外键约束：

SET FOREIGN_KEY_CHECKS=1;。那么，在第一个事务中的两 次读数据之间，由于第二个事务的修改，那么第一个事务两次读到的的数据可能是不一样的。这样就发生了在一个事务内两次读到的数据是不一样的，因此称为是不 可重复读。例如，一个编辑人员两次读取同一文档，但在两次读取之间，作者重写了该文档。当编辑人员第二次读取文档时，文档已更改。原始读取不可重复。如果 只有在作者全部完成编写后编辑人员才可以读取文档，则可以避免该问题。

#### MySQL外键约束的禁用与启用：

MySQL外键约束是否启用是通过一个全局变量标示的：

FOREIGN_KEY_CHECKS=0; 禁用状态

FOREIGN_KEY_CHECKS=1; 启用状态


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


### service层的事务的传播行为
如果你在你的Service层的这个方法中，除了调用了Dao层的方法之外，还调用了本类的其他的Service方法，那么在调用其他的Service方法的时候，这个事务是怎么规定的呢，我必须保证我在我方法里掉用的这个方法与我本身的方法处在同一个事务中，否则如果保证事物的一致性

PROPGATION_REQUIRED：这个配置项的意思是说当我调用service层的方法的时候开启一个事务(具体调用那一层的方法开始创建事务，要看你的aop的配置),那么在调用这个service层里面的其他的方法的时候,如果当前方法产生了事务就用当前方法产生的事务，否则就创建一个新的事务

```java
//********************sample***********************
ServiceA {   
       
       
     void methodA() {   
         ServiceB.methodB();   
     }   
  
}   
  
ServiceB {   
       
         
     void methodB() {   
     }   
       
}      
//*************************************************
```
我们这里一个个分析吧:

1： PROPAGATION_REQUIRED 
加入当前正要执行的事务不在另外一个事务里，那么就起一个新的事务
比如说，ServiceB.methodB的事务级别定义为PROPAGATION_REQUIRED, 那么由于执行ServiceA.methodA的时候，
         ServiceA.methodA已经起了事务，这时调用ServiceB.methodB，ServiceB.methodB看到自己已经运行在ServiceA.methodA
的事务内部，就不再起新的事务。而假如ServiceA.methodA运行的时候发现自己没有在事务中，他就会为自己分配一个事务。
这样，在ServiceA.methodA或者在ServiceB.methodB内的任何地方出现异常，事务都会被回滚。即使ServiceB.methodB的事务已经被
提交，但是ServiceA.methodA在接下来fail要回滚，ServiceB.methodB也要回滚



