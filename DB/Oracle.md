[TOC]

# Oracle安装

## 主目录
G:\SXTOracle

## 服务名
通常是全局数据库名

## Oracle实例是什么
(内存结构+一系列进程结构)
安装好oracle后，需要配置一个数据库，数据库是静态的，具体就是存储在硬盘的一系列文件；启动数据库即启动一个实例，就是运行起来的一系列管理数据库的后台进程和内存区域
![oracle_instance](./oracle_instance.jpg)


## oracle Instant Client + PLSQL使用方法

### 下载Instant Client

：http://www.oracle.com/technetwork/topics/winsoft-085727.html
选择：Instant Client for Microsoft Windows (32-bit) 64位的系统选择64 

下载完成之后解压到任意目录下，如我的：D:\clientOracle\instantclient_12_1

### 添加tnsnames.ora 文件
进入instant client 解压目录（D:\clientOracle\instantclient_12_1），添加文件夹network，然后在network下添加文件夹admin，在admin文件夹下添加tnsnames.ora文件

tnsnames.ora 文件内添加以下内容：
```
orcl=
(DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = xxx.xxx.xxx.xxx)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = orcl)
    )
)
orcl 是数据库名，HOST = xxx.xxx.xxx.xxx 你的远程数据库IP地址。
如存在多个数据库地址可以复制上面代码，追加在后面如：
orcl1=
(DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = xxx.xxx.xxx.xxx)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = orcl1)
    )
)
```

### 设置环境变量

在系统变量PATH中添加：instant client的解压目录，如：D:\开发工具\instantclient_12_1；

添加用户变量：

NLS_LANG 值 SIMPLIFIED CHINESE_CHINA.ZHS16GBK

TNS_ADMIN 值 D:\开发工具\instantclient_12_1\network\admin

### 设置PLSQL

打开PL/SQL,选择 tools->preferences->connection 

Oracle Home 设置为：D:\开发工具\instantclient_12_1

OCI library 设置为: D:\开发工具\instantclient_12_1\oci.dll

重启PL/SQL

### 选择刚才添加的数据库，输入帐号密码登录

oracle Instant Client 是ORACLE的客户端，配合PL/SQL就能在不安装数据库的情况下连接远程ORACLE数据库


## ERROR

### ORA-12560 TNS服务未启动

### ORA-00937 不是单组分组函数


### sql Developer设置java.exe
product/11.2.0/dbhome_1/jdk/bin/java.exe

## 监听问题
默认监听TCP端口1521
G:\SXTOracle\product\11.2.0\dbhome_1\network\admin\listener.ora
`注意：LISTENER中的host最好设置为主机名(HOST = Basketball)，使用localhost可能会在以后出问题`

## 监听程序/本地网络服务名配置
NetConfigurationAssistant官方工具
配置作用会作用到listener.ora和tnsnames.ora文件中

## jar包
就是一个项目(ZIP压缩)

## 各种账户默认密码
sys/change_on_install
system/manager
scott/tiger

## Oracle客户端字符集设置

### 检查编码
```sql
-- Oracle 版本查看
select * from v$version;
-- 检查数据库服务器编码
select * from nls_database_parameters where parameter ='NLS_CHARACTERSET';
-- 检查oracle客户端编码
select * from nls_instance_parameters where parameter='NLS_LANGUAGE';
```
oracle客户端在获取字符集设置信息时的优先级顺序依次为：session、环境变量、注册表、参数文件，因此可以通过设置这些位置实现客户端字符集设置的目的，因此本文采用设置session的方法，设置NLS_LANG变量值，从而覆盖所有设置值


# Oracle基本数据类型

## 数字类型

### NUMBER类型

NUMBER(P,S)是最常见的数字类型，可以存放数据范围为10^130~10^126（不包含此值)，需要1~22字节(BYTE)不等的存储空间。

P 是Precison的英文缩写，即精度缩写，表示有效数字的位数，最多不能超过38个有效数字

S是Scale的英文缩写，

Precison表示有效位数(有效数位：从左边第一个不为0的数算起，小数点和负号不计入有效位数(含小数点右边的数字))
Scale表示精确到多少位(即，精确到小数点左边或邮编多少位(+-决定))

Number值类型举例：

实际值:-:	数据类型 -	存储值:

1234567.89	Number		1234567.89

1234567.89	Number(8)	1234567

1234567.89	Number(6)	出错

1234567.89	Number(9,1)	1234567.9

1234567.89	Number(9,3)	出错

1234567.89	Number(7,2)	出错

1234567.89	Number(5,-2)	1234600

1234511.89	Number(5,-2)	1234500

1234567.89	Number(5,-4)	1230000

1234567.89	Number(\*,1)	1234567.9

0.012		Number(2,3)	0.012

0.23		Number(2,3)	出错


如果要存储的数据是定点数，则定点数的精度(p)和刻度(s)遵循以下规则：
1) 当一个定点数的整数部分的长度 > p-s 时，Oracle就报错
2) 当一个定点数的小数部分的长度 > s 时，Oracle就会舍入
3) 当s(scale)为负数时，Oracle就对小数点左边的s个数字进行舍入
4) 当s > p 时，p表示小数点后第s位(含)向左最多可以有多少位"有效数字"(如果"有效位数"大于p则Oracle报错)，小数点后s位向右的数字被舍入


### INTEGER类型

INTEGER是NUMBER的子类型，它等同于NUMBER(38,0)，用来存储整数。
若插入，更新的数值有小数，则会被四舍五入


# Oracle基础

## 用户与权限
创建用户
```
--创建用户
CREATE USER USER_NAME IDENTIFIED BY PASSWD; 
```
修改密码
```
--修改新密码
ALTER USER USER_NAME IDENTIFIED BY NEW_PASSWD; 

--修改用户密码
PASSWD USER_NAME;
```
删除用户
```SQL
--可选参数 CASCADE
DROP USER USER_NAME [CASCADE];

--注意：
/*
在进行删除用户操作时，如果此用户已创建表，删除时需要加参数“CASCADE”，它具有级联的作用
*/
```
给用户赋权限
```
GRANT 权限/角色 TO USER_NAME;
```
收回用户权限
```
REVOKE 权限/角色 FROM USER_NAME;
```
系统权限
```
-- “系统权限是数据库管理相关的权限”
CREATE SESSION							--登录权限
CREATE TABLE							--建表权限
CREATE INDEX							--创建索引权限
CREATE VIEW							--创建视图权限
CREATE SEQUENCE							--创建序列权限
CREATE TRRIGER							--创建触发器权限
```
常用的角色
一个角色包含多个权限
三种标准角色:
连接角色(connect role)
```
--“是授予用户的最基本的权利，能够连接到Oracle数据中，能够访问其他用户的表权限时”
CREATE SESSION		--创建会话
CREATE VIEW		--创建视图
CREATE SEQUENCE		--创建序列
```
资源角色(resource role)
```
--“具有创建表、序列、视图的权限”
CREATE TABLE		--创建表
CREATE TRIGGER		--创建触发器
CREATE PROCEDURE	--创建过程
CREATE SEQUENCE		--创建序列
CREATE TYPE		--创建类型
```
DBA角色(dba role)
```
--“是授予系统管理员的，拥有该角色的用户即系统管理员，拥有系统的所有权限”
--“包括无限制的空间限额和给其他用户授予各种权限的能力。system由dba用户拥有”
```
创建/授权/删除角色
除了前面讲到的三种系统角色----connect、resource和dba，用户还可以在oracle创建自己的role。用户创建的role可以由表或系统权限或两者的组合构成。为了创建role，用户必须具有create role系统权限
1》创建角色
　　语法： create role 角色名;
　　例子： create role testRole;

2》授权角色
　　语法： grant select on class to 角色名;
　　列子： grant select on class to testRole;
　　注：现在，拥有testRole角色的所有用户都具有对class表的select查询权限

3》删除角色
　　语法： drop role 角色名;
　　例子： drop role testRole;
　　注：与testRole角色相关的权限将从数据库全部删除

## 表空间
```
--创建表空间
CREATE TABLESPACE SPACE_NAME

--DATAFILE '/' 指向数据文件路径
--SIZE N(M) 表示初始化表空间为N(M)
--AUTOEXTEND ON NEXT 2M 自动扩展，每次扩展2M
--MAXSIZE UNLIMITED UNLIMITED最大扩展没有限制，N(M)最大扩展到N(M)
```
创建用户指定默认表空间
```
CREATE USER USER_NAME IDENTIFIED BY PASSWD DEFAULT TABLESPACE SPACE_NAME
```
修改用户默认表空间
```
ALTER USER USER_NAME IDENTIDIED BY PASSWD DEFAULT TABLESPACE SPACE_NAME
```
查看表表空间
```
SELECT * FROM v$TABLESPACE
```
查看用户默认表空间
```
SELECT USERNAME, DEFAULT_TABLESPACE FROM DBA_USERS WHERE USERNAME = 'SCOTT';
--用户名SCOTT必须为大写
```

## 表结构操作
```SQL
--创建表1
CREATE TABLE TABLE_NAME(
	COLUMN_1 DATA_TYPE,
    COLUMN_2 DATA_TYPE
);

--创建表2
CREATE TABLE TABLE_NAME AS SELECT COLUMN_1, COLUMN_2 ...FROM TABLE_NAME;

--修改表
ALTER TABLE 语句添加、修改或删除列的语法

--添加列
ALTER TABLE TABLE_NAME ADD(
	COLUMN_1 DATA_TYPE,
    COLUMN_2 DATA_TYPE
);

ALTER TABLE TABLE_NAME ADD COLUMN_1 DATA_TYPE;

--修改列
ALTER TABLE TABLE_NAME MODIFY(
	COLUMN_1 DATA_TYPE
);

--删除列
ALTER TABLE TABLE_NAME DROP(
	COLUMN_1,
    COLUMN_2
);

--修改表名称
RENAME TABLE TO NEW_TABLE_NAME

--修改列名
ALTER TABLE TABLE_NAME RENAME COLUMN OLD_COLUMN TO NEW COLUMN;

--查看表结构
DESC 表名;
```

## 表约束

### 主键约束(primary key)
要求主键列数据唯一，并且不允许为空。主键可以包含表的一列或多列，如果包含表的多列，则需要在表级定义
```
--创建学生表
CREATE TABLE student(
`--sno NUMBER(3) CONSTRAINT pk_student PRIMARY KEY, --在列级别定义主键约束` 
--在表级别定义主键约束
--定义主键约束
`--CONSTRAINT pk_student PRIMARY KEY (sno)`
--PRIMARY KEY (sno) --简化版
);
```

### 唯一约束(unique)
要求该列唯一，允许为空

邮箱地址使用 唯一约束

表级别 定义 唯一约束
`CONSTRAINT uk_student_email UNIQUE(email)`

表级别 创建唯一索引(联合字段)
```
create unique index T_QYL_LEAVE_STATIS_TODAY_UNI
	on T_QYL_LEAVE_STATISTICS_TODAY (SCHOOL_ID, GRADE_ID, CLASS_ID, PERSON_TYPE)
/

create unique index T_QYL_LEAVE_STATIS_HIS_UNI
	on T_QYL_LEAVE_STATISTICS_HISTORY (SCHOOL_ID, GRADE_ID, CLASS_ID, PERSON_TYPE, STATISTICS_DATE)
/
```


### 非空约束(not null)

`sname VARCHAR2(15) CONSTRAINT nn_student_sname NOT NULL,--非空约束只能在字段级别添加`



### 检查约束(check)

--表级别 定义 检查约束
`CONSTRAINT ck_student_age CHECK(age BETWEEN 18 AND 30)`


### 外键约束(foreign key)
```
--创建学生表
CREATE TABLE student(
      
   --表级别 定义 外键约束
   CONSTRAINT fk_student_cno FOREIGN KEY(cno) REFERENCES clazz(cno)
);
```

对于主表的删除和修改主键值的操作，会对依赖关系产生影响，以删除为例：当要删除主表的某个记录（即删除一个主键值，那么对依赖的影响可采取下列3种做法：
RESTRICT方式：只有当依赖表中没有一个外键值与要删除的主表中主键值相对应时，才可执行删除操作。
CASCADE方式：将依赖表中所有外键值与主表中要删除的主键值相对应的记录一起删除
SET NULL方式：将依赖表中所有与主表中被删除的主键值相对应的外键值设为空值

```
--撤销FOREIGN KEY约束
ALTER TABLE prders
DROP FOREIGN KEY fk_perOrders
```


## Between子句

当使用BETWEEN运算符为SELECT语句返回的行形成搜索条件时，值返回其值在指定范围内的行.
`expression [ NOT ] BETWEEN low AND high`

low 和high - low和hight指定要测试的范围的下限值和上限值。low和hight值可以是文字或表达式。
expression - 是low和hight定义的范围内测试的表达式。 为了能够比较，expression，low和hight的数据类型必须是相同的。
AND - AND运算符充当占位符来分隔low和hight的值。


## SQL中group by的用法

### 概述
“Group By”从字面意义上理解就是根据“By”指定的规则对数据进行分组，所谓的分组就是将一个“数据集”划分成若干个“小区域”，然后针对若干个“小区域”进行数据处理。

### group by中的易错点
使用了group by子句后， select列表中的字段如果不在分组函数中，就必须要出现在group by子句中
`原因：MAX(sal)返回的一定是单个数值，但是拿到该数值工资的人数可能有多个，无法和Max(sal)返回的单一值组成ResultSet`

常见的分组函数如下表：
函数  作用  支持性
sum(列名) 求和  　　　　
max(列名) 最大值 　　　　
min(列名) 最小值 　　　　
avg(列名) 平均值 　　　　
first(列名) 第一条记录 仅Access支持
last(列名)  最后一条记录  仅Access支持
count(列名) 统计记录数 注意和count(`*`)的区别
示例5：求各组平均值
`select 类别, avg(数量) AS 平均值 from A group by 类别;`

示例6：求各组记录数目
`select 类别, count(*) AS 记录数 from A group by 类别;`

## SQL执行顺序
from 取数据
where 过滤数据
groupby 进行分组
having 对分组进行限制
select 查具体字段
orderby 最后的结果进行排序

综合练习
```
--对薪水>1200的员工，按deptno分组，分组后平均薪水>1500
--查询--->分组内的平均工资，按照工资的倒序进行排序
  SELECT deptno, AVG(sal) avgSal
  FROM emp 
  WHERE sal>1200 
  GROUP BY deptno 
  HAVING AVG(sal)>1500
  ORDER BY avgSal DESC;
```

## SQL JOINS
![SQL_JOINS](Visual_SQL_JOINS_orig.jpg)

left join 和 right join

A表left join B表 等价于 B表 right join A表

inner join 
规律：
A表inner join B表：则返回A表和B表同时符合条件的记录。
```
两种写法，后者使用的居多

SELECT `user`.`name`,`user`.mobile,`order`.order_id,`order`.`status`,`order`.amout
 FROM `order` INNER JOIN `user` ON `user`.uid=`order`.uid;

等价于

SELECT `user`.`name`,`user`.mobile,`order`.order_id,`order`.`status`,`order`.amout
 FROM `order`,`user` WHERE `user`.uid=`order`.uid;
```



## 子查询
```
SELECT empno,ename,sal 
FROM emp 
WHERE sal>(SELECT AVG(sal) FROM emp);

```

## 特点
子查询在主查询前执行一次
主查询使用子查询的结果

## 单行子查询
单行子查询只返回一行记录
对单行子查询可使用[单行记录比较运算符]
```
--查询工资比所有"SALESMAN"的最高工资更高的雇员信息
--单行子查询
SELECT empno,ename,sal
FROM emp
WHERE sal>(SELECT MAX(sal) FROM emp WHERE job='SALESMAN')
```

## 多行子查询
多行子查询返回多行记录
对多行子查询只能使用[多行记录比较运算符]
ALL 和子查询返回的所有值比较
ANY 和子查询返回的任意一个值比较
IN 等于列表中的任何一个

```
--查询工资比所有"SALESMAN"的最高工资更高的雇员信息
--多行子查询
SELECT empno,ename,sal
FROM emp
WHERE sal>ALL(SELECT sal FROM emp WHERE job='SALESMAN')
```

## 模糊查询
`like '%ALL%'` 包含字符ALL
`like '_A%'` 第二个字符是A


## where子句

and 比 or 的优先级高


## Oracle游标

### 参数游标

在定义游标时加入参数的游标，可以配合游标for循环快速找到需要的数据。

游标for循环：
隐含的执行了打开提取关闭数据，代码精简很多

`
for RESTINFO in cur loop

  statement;

end loop;
`

例: 使用游标for循环打印员工信息
```
DECLEAR 
CURSOR emp_cursor IS SELECT empno, ename, job FROM emp;
BEGIN
  FOR emp_record IN emp_cursor LOOP
  DBMS_OUTPUT.PUT_LINE('员工号：'||emp_record.empno||'员工姓名'||emp_record.ename||'员工职位'||emp_record.job)
  END LOOP;
END;
```


# Oracle事务管理

一个事务起源于一条DML语句
结束于以下情况：
1用户显示执行commit 或 rollback
2用户执行 DDL
3数据库正常连接断开，事务会自动提交
4非正常断开连接时，自动回滚事务

## 锁表

--查看被锁的表(管理员权限)
select b.owner,b.object_name,a.session_id,a.locked_mode from v$locked_object a,dba_objects b where b.object_id = a.object_id;

--解锁方法：(管理员权限)
alter system kill session '5'; -- 5是session_id


# Oracle函数

## decode函数用法

decode(条件,值1,返回值1,值2,返回值2,...值n,返回值n,缺省值)

该函数的含义如下：
```
IF 条件=值1 THEN
　　　　RETURN(翻译值1)
ELSIF 条件=值2 THEN
　　　　RETURN(翻译值2)
　　　　......
ELSIF 条件=值n THEN
　　　　RETURN(翻译值n)
ELSE
　　　　RETURN(缺省值)
END IF
```

使用：
1、比较大小

2、此函数用在SQL语句中

Decode 函数与一系列嵌套的 IF-THEN-ELSE语句相似。

```
-- 查询走读生请假(今天)
select
   a.MS_START_LEAVE "msStartLe",
   a.MS_CLASS_LEAVE "msClassLe",
   a.AS_START_LEAVE "asStartLe",
   a.AS_START_LEAVE "asClassLe",
   a.NS_START_LEAVE "nsStartLe",
   a.NS_CLASS_LEAVE "nsClassLe",
   a.NS_AFTER_LEAVE "nsAfterLe"
FROM t_qyl_leave_statistics_today a
WHERE a.SCHOOL_ID = 152
  --AND a.GRADE_ID = 13760 -- #{gradeId}
  --AND a.CLASS_ID = 1459 -- #{classId}
  AND a.PERSON_TYPE = 0
```



## oracle取上下行分析函数

lag()和lead()

lag(EXPR,<OFFSET>,<DEFAULT>)
LEAD(EXPR,<OFFSET>,<DEFAULT>)

表示根据COL1分组，在分组内部根据COL2排序，而这个值就表示魅族内部排序后的顺序编号(组内连续的唯一的)
lead()下一个值 lag()上一个值


```sql
-- 根据班级id查出该班级学生photo列表(上一个下一个学生)
select t.id             as "studentId",
       t.student_img    as "studentImg",
       t.student_name   as "studentName",
       t.sex            as "studentSex",
       c.class_name     as "className",
       lead(t.id) over(order by t.student_name) as "nextStuId",
       lead(student_name) over(order by t.student_name) as "nextStuName",
       lag(t.id) over(order by t.student_name) as "preStuId",
       lag(student_name) over(order by t.student_name) as "preStuName"
  from t_student t
  left join t_class c
    on c.id = t.class_id
 where t.class_id = 73195
```
student表数据
3760302   ces 1 6.01班
3760130   本蹦儿芭 1 6.01班
3682225   程涵义1  0 6.01班
3682234   程涵义10 0 6.01班
3682324   程涵义100  0 6.01班
3682325   程涵义101  0 6.01班

sql运行结果
3760302   ces 1 6.01班 3760130 本蹦儿芭   
3760130   本蹦儿芭 1 6.01班 3682225 程涵义1  3760302 ces
3682225   程涵义1  0 6.01班 3682234 程涵义10 3760130 本蹦儿芭
3682234   程涵义10 0 6.01班 3682324 程涵义100  3682225 程涵义1
3682324   程涵义100  0 6.01班 3682325 程涵义101  3682234 程涵义10
3682325   程涵义101  0 6.01班 3682326 程涵义102  3682324 程涵义100
3682326   程涵义102  0 6.01班 3682327 程涵义103  3682325 程涵义101




## 字符函数
`TO_CHAR( value [, format_mask] [, nls_language] )`

- value
A number or date that will be converted to a string.
- format_mask
Optional. This is the format that will be used to convert value to a string.
- nls_language
Optional. This is the nls language used to convert value to a string.

### with Numbers
```
TO_CHAR(1210.73, '9999.9')
Result: ' 1210.7'

TO_CHAR(-1210.73, '9999.9')
Result: '-1210.7'

TO_CHAR(1210.73, '9,999.99')
Result: ' 1,210.73'

TO_CHAR(1210.73, '$9,999.00')
Result: ' $1,210.73'

TO_CHAR(21, '000099')
Result: ' 000021'
```

### with Dates
Parameter|	Explanation
-|-
YEAR|	Year, spelled out
YYYY|	4-digit year
YYY|	Last 3, 2, or 1 digit(s) of year.
YY|
Y|
IYY|	Last 3, 2, or 1 digit(s) of ISO year.
IY|
I|
IYYY|	4-digit year based on the ISO standard
Q|	Quarter of year (1, 2, 3, 4; JAN-MAR = 1).
MM|	Month (01-12; JAN = 01).
MON|	Abbreviated name of month.
MONTH|	Name of month, padded with blanks to length of 9 characters.
RM|	Roman numeral month (I-XII; JAN = I).
WW|	Week of year (1-53) where week 1 starts on the first day of the year and continues to the seventh day of the year.
W|	Week of month (1-5) where week 1 starts on the first day of the month and ends on the seventh.
IW|	Week of year (1-52 or 1-53) based on the ISO standard.
D|	Day of week (1-7).
DAY|	Name of day.
DD|	Day of month (1-31).
DDD|	Day of year (1-366).
DY|	Abbreviated name of day.
J|	Julian day; the number of days since January 1, 4712 BC.
HH|	Hour of day (1-12).
HH12|	Hour of day (1-12).
HH24|	Hour of day (0-23).
MI|	Minute (0-59).
SS|	Second (0-59).
SSSSS|	Seconds past midnight (0-86399).
FF|	Fractional seconds.

```
TO_CHAR(sysdate, 'yyyy/mm/dd')
Result: '2003/07/09'

TO_CHAR(sysdate, 'Month DD, YYYY')
Result: 'July 09, 2003'

--You will notice that in some TO_CHAR function examples, the format_mask parameter begins with "FM".
--This means that zeros and blanks are suppressed. This can be seen in the examples below.
TO_CHAR(sysdate, 'FMMonth DD, YYYY')
Result: 'July 9, 2003'

TO_CHAR(sysdate, 'MON DDth, YYYY')
Result: 'JUL 09TH, 2003'

TO_CHAR(sysdate, 'FMMON DDth, YYYY')
Result: 'JUL 9TH, 2003'
```


## 字符串函数

### Oracle ||运算符
`string1 || string2 [ || string_n ]`
string1： 第一个要连接的字符串。
string2：第二个要连接的字符串。
string_n：可选项，第n个要连接的字符串。

```
'oraok' || '.com'
-- Result: 'oraok.com'

'a' || 'b' || 'c' || 'd'
-- Result: 'abcd'
```

### Oracle Concat()函数
`CONCAT( string1, string2 )`
string1：第一个要连接的字符串。
string2：第二个要连接的字符串

```
CONCAT('Oraok', '.com')
-- Result: 'Oraok.com'
```
[注1]如果需要连接多个值，那么我们可以嵌套多个CONCAT函数调用。


## 数值函数

## 日期函数
to_date()函数
`SELECT to_date('17-07-2017', 'dd-MM-yyyy') FROM dual;`

Oracle 中有两种主要日期与时间类型，DATE 以及 TIMESTAMP。
DATE: 仅存 年 月 日
TIMESTAMP: 保存 年 月 日 时 分 秒 纳秒

### 毫秒与日期的相互转换示例
毫秒转换为日期
```sql
SELECT TO_CHAR(1406538765000 / (1000 * 60 * 60 * 24) + 
TO_DATE('1970-01-01 08:00:00', 'YYYY-MM-DD HH:MI:SS'), 'YYYY-MM-DD HH24:MI:SS') AS CDATE 
FROM DUAL;
```

日期转换毫秒
```sql
SELECT TO_NUMBER(TO_DATE('2014-07-28 17:12:45', 'YYYY-MM-DD HH24:MI:SS') - 
TO_DATE('1970-01-01 8:0:0', 'YYYY-MM-DD HH24:MI:SS')) * 24 * 60 * 60 * 1000 
FROM DUAL;
```
注意：毫秒转换为日期 格式化的时间可以是12小时制和24小时制。

## 转换函数


## 控制流函数
### NVL函数
NVL函数　Oracle/PLSQL中的一个函数。
格式为：
`NVL( string1, replace_with)`
功能：如果string1为NULL，则NVL函数返回replace_with的值，否则返回string1的值。
注意事项：string1和replace_with必须为同一数据类型，除非显示的使用TO_CHAR函数。
例：NVL(TO_CHAR(numeric_column), 'some string') 其中numeric_column代指某个数字类型的值。
例：nvl(yanlei777,0) > 0
NVL(yanlei777, 0) 的意思是 如果 yanlei777 是NULL， 则取 0值


## 多行函数(分组函数)(给好多行记录只会产生一行输出)
“所有的雇员中平均工资多少，最高工资多少。。。”
-- [1]sum 求和
-- [2]avg 求平均值
-- [3]count 计数
-- [4]max 求最大值
-- [5]min 求最小值

--统计
select sum(sal), avg(sal), count(empno) from emp;

-- 多行函数可以操作什么类型的数据?
-- 只能操作数值
`select sum(sal) from emp;`正常
`select avg(ename) from emp;`报错

-- 所有类型都能操作
`select count(ename) from emp;`
`select max(ename), min(hiredate) from emp`

### 多行函数不能和普通字段同时查询
`SELECT  deptno, sum(sal), avg(sal), max(sal) from emp where deptno=10;`
报错 ORA-00937: 不是单组分组函数
很好理解：你既然指定了分组函数，又同时制定了其他列，还想不按照指定的列来分组，你到底想让oracle怎么做呢？这根本就得不出结果。就像你需要统计班上男女生的人数，但是又不能分组，只能在一条数据里表示出来，怎么能办得到呢？
`select deptno from emp where deptno=10;`正常

--计算所有员工的平均工资
`SELECT  avg(sal), max(sal) from emp ;`

--统计每个部门的总工资，总人数，平均工资 排除 部门10
-- where 子句要写在 group by之前  先过滤再分组
`select deptno, sum(sal), count(*), avg(sal) from emp where deptno<>10 group by deptno order by deptno;`


### CASE WHEN 在语句中不同位置的用法

#### SELECT CASE WHEN 用法
```
SELECT grade, 
	COUNT(CASE WHEN sex = 1 THEN 1  /*sex 1为男生, 2为女生*/
	ELSE NULL
	END) 男生数
	COUNT(CASE WHEN sex = 2 THEN 1
	ELSE NULL
	END) 女生数
FROM students GROUP BY grade;
```


## 注释
```
--添加表注释：
COMMENT ON table tb_order IS '订单表';
--添加字段注释：
comment on column tb_order.orderno is '订单号';
comment on column tb_order.genetime is '订单生成时间';
comment on column tb_order.accid is '账号';
comment on column tb_order.orderstat is '状态(1正常、2申请取消、3取消中、0已取消)';
comment on column tb_order.paid is '是否已支付';
```

# 序列

## 创建序列
create sequence seq_student_sno;

## 创建序列指定详细信息
```
create sequence SEQ_T_REST_NOMEAL
nomaxvalue
start with 1   --从1开始
increment by 1 --增量为1
nocycle
nocache
;
```

## 查询
先 select 序列名.nextval(该值每次会先自增再参与运算)
再 select 序列名.currval

## 删除序列
drop sequence 序列名;

# 索引
索引是关系数据库中用于存放每一条记录的一种对象，主要目的是加快数据的读取速度和完整性检查。建立索引是一项技术性要求高的工作。一般在数据库设计阶段的与数据库结构一道考虑。应用系统的性能直接与索引的合理直接有关。下面给出建立索引的方法和要点。

数据库的索引和词典中的索引非常相似, 他是对表的一列或多列进行排序的结构. 如果表中某一列经常被作为关键字搜索, 则建议对此列创建索引.
Oracle支持以下几种索引结构:
- B-树索引
- B-树簇索引
- 哈希簇索引
- 全局和本地索引
- 反向索引
- 位图索引
- 函数索引
- 域索引

```sql
-- 在MOBILE表的TEL_NUM字段创建ASC索引
-- 并且唯一索引
create unique index IDX_T_MOBILE_TEL_NUM on T_MOBILE (TEL_NUM)
```

## 建立索引
1. CREATE INDEX命令语法:
```
CREATE INDEX
CREATE [unique] INDEX [user.]index
ON [user.]table (column [ASC | DESC] [,column
[ASC | DESC] ] ... )
[CLUSTER [scheam.]cluster]
[INITRANS n]
[MAXTRANS n]
[PCTFREE n]
[STORAGE storage]
[TABLESPACE tablespace]
[NO SORT]
Advanced
```
 
其中：
   schema ORACLE模式，缺省即为当前帐户
   index 索引名
   table 创建索引的基表名
   column 基表中的列名，一个索引最多有16列，long列、long raw
              列不能建索引列
   DESC、ASC 缺省为ASC即升序排序
   CLUSTER 指定一个聚簇（Hash cluster不能建索引）
   INITRANS、MAXTRANS 指定初始和最大事务入口数
   Tablespace 表空间名
   STORAGE 存储参数，同create table 中的storage.
   PCTFREE 索引数据块空闲空间的百分比(不能指定pctused)
   NOSORT 不（能）排序（存储时就已按升序，所以指出不再排序）

2.建立索引的目的：

 
建立索引的目的是：
l 提高对表的查询速度；
l 对表有关列的取值进行检查。

 
但是，对表进行insert,update,delete处理时，由于要表的存放位置记录到索引项中而会降低一些速度。
注意：一个基表不能建太多的索引；
      空值不能被索引
      只有唯一索引才真正提高速度,一般的索引只能提高30%左右。

## 	修改/删除 索引
ALTER/DROP INDEX
修改
不可用: UNUSABLE
重新使用: REBUILD


# 视图view

## 作用
视图可以隐藏表格的部分数据

将复杂的查询简单化


## 定义只读视图
```
--定义只读视图: 只能执行DQL, 不能执行DML
CREATE OR REPLACE VIEW view_cla AS (
     SELECT c.*,COUNT(s.sno) countStu, AVG(age) avrAge
     FROM student s, clazz c
     WHERE s.cno(+) = c.cno
     GROUP BY c.cno, c.cname, c.cdate
)WITH READ ONLY;
```

## 基于视图来创建视图
```
CREATE OR REPLACE VIEW view_test AS (SELECT cname, countStu FROM view_cla);
SELECT * FROM view_test;
```


# rowid 和 rownum

rownum只能使用：<,<=
`select rownum,id,age,name from loaddata where rownum > 2`

rownum>2，没有查询到任何记录。
因为rownum总是从1开始的，第一条不满足去掉的话，第二条的rownum 又成了1。依此类推，所以永远没有满足条件的记录。

可以这样理解：rownum是一个序列，是Oracle数据库从数据文件或缓冲区中读取数据的顺序。
它取得第一条记录则rownum值为1，第二条为2。依次类推。

当使用“>、>=、=、between...and”这些条件时，从缓冲区或数据文件中得到的第一条记录的rownum为1，不符合sql语句的条件，会被删除，接着取下条。

下条的rownum还会是1，又被删除，依次类推，便没有了数据

`因为检索和操作rownum的时候游标的指向必须从1开始，不能跳过`
另外还要注意：rownum不能以任何基表的名称作为前缀

## 分页
```sql
--分页查询  另外还要注意：rownum不能以任何基表的名称作为前缀
SELECT b.* FROM (
    SELECT ROWNUM rn, a.* FROM (
           SELECT t.* FROM emp t ORDER BY sal DESC
    ) a WHERE ROWNUM<=10
) b WHERE rn>5;

-- 每页显示条数: size
-- 当前要显示第几页: page
SELECT b.* FROM (
    SELECT ROWNUM rn, a.* FROM (
           SELECT t.* FROM emp t ORDER BY sal DESC
    ) a WHERE ROWNUM<=15
) b WHERE rn>10;
```

# 数据库导入导出

## PL/SQLdeveloper菜单里的导入导出工具三种导出文件格式的区别

DMP格式：
首先是通用性的问题，dmp文件是oracle原生的导入导出文件，它本身是二进制文件，导入导出速度快，压缩率高，移植性好可以跨平台使用但是只限于oracle数据库之间，还可以包含权限，但是导入到另一个数据库时受到数据表空间、用户名等约束，这是可以用PLSQLdeveloper工具tool菜单中的Export User Object导出你想要的表空间和表的sql脚本或者你可以直接写sql新建表空间和表。还有一点这个工具是向下兼容的也就是说高版本的oracle数据库导出的文件不可以导入到低版本的oracle数据库中，低版本的dmp文件也只能导入到只比他高一个版本的oracle数据库中（附录中列出了对于版本问题的简单总结）。高版本想低版本导数据就要就要选择其他两种文件格式了。

然后是速度问题，通过dmp文件导入数据库，默认是先导入数据，再创建索引，所以dmp方式速度上会比较高`N+log2N`。

不过在实际的工作环境中exp/imp命令方式的最大难点在于错误处理，因为该方式涉及到的各项约束较多可能会出现某些数据导入不成功，此时排查错误并修正数据需要仔细甄别。另外oracle版本的问题在实际工作中也是一个比较麻烦的问题。


SQL格式，
顾名思义，sql格式的文件就是一个sql的运行脚本文件，这决定了这个文件可以在几乎所有的主流数据库运行，还可以在文本编辑器上查看修改，通用性比较好，但是正因为需通用于大部分主流数据库，所以它的sql文件里，只能保存通用类型，如oracle的大数据类型clob，blob在使用sql导入导出时，就会发生错误。遇到其他数据库的特定类型，也是如此。而且假使表比较多，数据量比较大的话，得到的相应的sql文件也比较多，不方便管理和使用。         

不过效率上sql不如上面的dmp文件，适合小批量的数据处理。


PDE格式，
这是PLSQLdeveloper这个oracle数据库管理工具特有的格式，只能通过PLSQL developer导出数据产生，也只能通过PLSQL developer将其中数据导入到数据库。文件也不能通过编辑器查看和编辑。不过这种方式不受源数据表空间、用户名等约束，且数据量更小。可以处理clob，blob等大类型，但是也只能用于oracle。不过通过pde文件导入数据是，默认是先建立了索引，之后再向表中插入数据，插入数据时要维护索引`（N*log2N）`，所以速度比较慢，建议当通过pde导入数据时，可以选择不保留索引，或者先创建table，然后删除索引，最后导入数据；


## 导入导出dmp文件

装了oracle客户端(instantclient_11_2 须下载)后，
使用exp导出数据
使用imp导入数据 
```sql
exp wxcedb/wxcedb@10.0.12.31:1521/testlis file=d:\daochu.dmp full=y

imp home/xb101406@10.243.5.101:1521/xe  file=f:\daochu.dmp full=y
```


## PL/SQL重点--游标


# JDBC(Java Data Base Connectivity,Java数据库连接)
是一种用于执行SQL语句的Java API，为多种关系数据库提供统一访问
它由一组由Java语言编写的类和接口组成

内容：供程序员调用的接口与类，集成在java.sql和javax.sql包中，如：
DriverManager类 作用：管理各种不同的JDBC驱动
Connection接口
Statement接口
ResultSet接口

## JDBC驱动
提供者：数据库厂商
作用：负责连接各种不同的数据库

JDBC对Java程序员而言是API，对实现与数据库连接的服务提供商而言是接口模型。

SUN公司制定规范 制订了规范JDBC(连接数据库规范)
数据库厂商微软，甲骨文等分别提供实现JDBC接口的驱动jar包
程序员学习JDBC规范来应用这些jar包里的类

JDBC可做三件事
与数据库建立连接
发送操作数据库的语句
处理结果集

## JDBC访问数据库步骤
加载一个Driver驱动
创建数据库连接(Connection)
创建SQL命令发送器statement
使用statement发送SQL命令并获取结果
处理SQL结果
关闭资源

## ResultSet
表示数据库结果集的数据表，通常通过执行查询数据库的语句生成。 
### RS注意点
```java
rs = prest.executeQuery();
if (rs.next()){
    return rs.getInt(1);
}
```
rs.getInt(参数从1开始)

## PreparedStatement
灵活指定SQL语句中的变量，避免非安全的SQL拼接构造过程，SQL拼接构造过程容易遭受SQL注入恶意攻击。

## Batch
批处理
```java
//关闭自动提交
conn.setAutoCommit(false);

for(int i=0; i<list.size();i++){
    Num num = list.get(i);
    DBUtil.bindParam(prest, num.getNno(), num.getNnumber(), num.getNtype());
    prest.addBatch();
}
//TODO Batch执行
prest.executeBatch();
//手动提交事务
conn.commit();
```
其中，`prest.addBatch();`将构建好的prest添加到批处理，
`prest.executeBatch();`一次性执行prest的批操作

## CallableStatement
调用存储过程



##连接字符串是否设置了编码，如
jdbc:oracle:thin:@10.4.72.117:1521/ORCL


## Keywords

Dec 22, 2017()
`oracle中没有value关键字，只有values关键字`


reserved keyword 保留字



