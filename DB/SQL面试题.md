

126 是否有过MySQL调优经验？、
	127 开发中使用过哪些调优工具？
	128 如何监控线上环境中执行比较慢的SQL？ 
	129 如何分析一条满SQL？
	### 记录写入文件
	1.默认关闭
	SHOW VARIABLES LIKE '%slow_qurey_log%';
	默认情况下，slow_query_log的值为OFF，表示慢查询日志是禁用的。
	1 开启： set blobal 	slow_query_log=1; 只对窗口生效，服务重启失效
	
	1 慢查询日志记录long_query_time时间
	`SHOW VARIABLES LIKE '%long_query_time%';`
	`SHOW BLOBAL VARIABLES LIKE '%long_query_time%';`

	全局变量设置，对所有客户端有效，但，必须是设置后进行登陆的客户端。
	SET GLOBAL long_query_time=0.1;
	
	对当前会话连接立即生效，对其他客户端无效。
	SET SESSION long_query_time=0.1; # session 可省略。
	
	2 分析日志
	`记录慢SQL并后续分析`
	SELECT * FROM emp;
	SELECT * FROM emp WHERE deptId > 1;
	
	`查询当前系统中有多少条慢查询记录或者直接看慢查询日志`
	/var/lib/mysql/localhost-slow.log
	SHOW GLOBAL STATUS LIKE '%slow_queries%';
	
	3 日志分析工具mysqldumpslow
	① 在生产环境中，如果要手动分析日志，查询，分析SQL，显然是个体力活，MySQL提供了日志分析工具mysqldumpslow.
	② 查看mysqldumpslow的帮助信息
	a)	mysqldumpslow --help
	-a: 将数字抽象成N, 字符串抽象成S
	-s:	时表示按照何种方式排序
	
	c:	访问次数
	l:	锁定时间
	r:	返回记录
	**t:**	**查询时间**
	al:	平均锁定时间
	ar:	平均返回记录数
	
	
	
	
	
1 什么是小表驱动大表
用小的数据集去驱动(可理解为匹配)大的数据集

2 为什么使用小表驱动大表
表A有20条数据,表B有20万数据.外部执行一次连接,内部要执行多次.
​按照小表驱动大表,即A驱动B
for(20条){
	for(20万条){
    
	}
}

​大表驱动小表,即B驱动A
for(20万){
	for(20条){
	}
}

小的循环在外层,表连接需要20次
大的循环在外层,表连接需要20万次,浪费数据库资源
总结: 小表驱动大表的主要目的是通过减少表连接创建的次数,加快查询速度.

3 判断驱动表与非驱动表
	1 LEFT JOIN 左连接,左边为驱动表,右边为被驱动表.
	2 RIGHT JOIN 右连接,右边为驱动表,左边为被驱动表.
	3 INNER JOIN 内连接, mysql会选择数据量比较小的表作为驱动表，大表作为被驱动表.
	4 可通过EXPLANIN查看SQL语句的执行计划,EXPLANIN分析的第一行的表即是驱动表.

	LEFT JOIN :左连接小表驱动大表
	​	1 左边是驱动表,右边是被驱动表
	​	2 小表驱动大表优于大表驱动小表
	​	3 驱动表索引没有生效,被驱动表索引有效
	LEFT JOIN: 内连接,表1驱动表2
	​	1 数据库会自动选择数据量小的作为驱动表,大表作为被驱动表
	​	2 执行效率,和左连接执行效率相差不大
	​	3 驱动表索引没有生效,被驱动表索引有效

4 Exists和in的使用场景
SELECT * FROM A WHERE ID IN (SELECT ID FROM B)   
当B表的数据较小时,IN 优于Exists.

SELECT * FROM A WHERE  EXISTS (SELECT 1 FROM B WHERE B.ID = A.ID)
当A表的数据集小于B表时,用Exists优于IN.

### 查询的模糊匹配

尽量避免在一个复杂查询中使用LIKE ‘%param1%’ 红色标识位置的百分号会导致相关列的索引无法使用，最好不要用。

解决办法：
其实只需要对该脚本略做改进，查询速度便会提高近百倍。如下：

a 修改前台程序
把查询条件的供应商名称一栏由原来的文本输入改为下拉列表，用户模糊输入供应商名称时，在前台就帮忙定位到具体吊供应商，这样在调用后台程序时，这个列就可以直接用等号来关联了。

b 直接修改后台
根据输入条件，先查出符合条件的供应商，并把相关记录保存在一个临时表中，让那后再用临时表去做复杂关联。


### 索引问题

在做性能跟踪分析过程中，经常发现有不少后台程序的性能问题是因为缺少合适索引造成的，有些表甚至一个索引都没有。这种请求往往都是因为在设计表时，没去定义索引，而开发初期，由于表记录很少，索引创建与否，可能对性能没啥影响，开发人员因此也为多加重视。然而一旦程序发布到生产环境，随着时间的推移，表记录越来越多。

这时缺少索引，对性能的影响越来越大。

这个问题就需要数据库设计人员和开发人员共同关注

法则：不要再建立的索引的数据列上进行下列操作：
* 避免对索引字段进行计算操作
* 避免在索引字段上使用not, <>, !=
* 避免在索引字段上使用IS NULL和IS NOT NULL
* 避免在索引列上出现数据类型转换
* 避免在索引字段上使用函数
* 避免在索引的列中使用空值


### 复杂操作

部分UPDATE, SELECT语句写的很复杂(经常嵌套多级子查询)--可以适当考虑拆成几步，先生成一些临时数据表，在进行关联操作


### 在可以使用UNION ALL的语句里，使用了UNION
UNION因为会将各查询子集吊记录做比较，故比起UNION ALL，通常速度都会慢上许多。
一般来说，如果使用UNION ALL能满足要求的话，无比使用UNION ALL。还有一种情况大家可能会拉忽略掉，就是虽然要求及个子集的并集需要过滤掉重复记录，但由于脚本的特殊性，不可能存在重复记录，这时便应该使用UNION ALL，


### 在WHERE语句中，尽量避免对索引字段进行计算操作


### 对WHERE语句的法则

* 避免在WHERE子句中使用in, not in, or或者having
可以使用exist和not exist代替in和not in
可以使用表链接代替exist. having可以用where代替，如果无法代替可以分两步处理.


* 不要以字符格式声明数字，要以数字格式声明字符值。(日期同样)否则会使索引失效，产生全表扫描。

例子:
```sql
SELECT emp.ename, emp.job FROM emp WHERE emp.empno = 7369;

--不要使用:SELECT emp.ename, emp.job FROM emp WHERE emp.empno = '7369'
```

