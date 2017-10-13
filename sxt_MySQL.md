

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

##查询MySQL字符集相关参数
show variables like '%character%';

##MySQL字符序
show variables like '%collation%';
mysql的collation大致的意思就是字符序。首先字符本来是不分大小的，那么对字符的>, = , < 操作就需要有个字符序的规则。collation做的就是这个事情，你可以对表进行字符序的设置，也可以单独对某个字段进行字符序的设置。一个字符类型，它的字符序有多个

##连接字符串是否设置了编码，如
jdbc:mysql://192.168.1.211:3306/xxx?useUnicode=true&characterEncoding=utf-8

## MySQL汉字乱码问题
新产品开发，有时候需要迁移历史数据，而且往往还是异构系统的数据。
这时候常常会遇到乱码的问题，原因主要是因为字符集不匹配引起的。
对于MySQL而言，存在`客户端字符集、服务器字符集、数据库字符集以及连接字符集`等变量，

如果你不希望服务器做任何的结果转换，那么可以把character_set_results设置为NULL:
```
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

