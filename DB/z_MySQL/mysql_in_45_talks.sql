


# 基础篇(8讲)




## 03|事务隔离：为什么你改了我还看不见？

查看锁相关SQL
```SQL
-- 查看当前的事务
select * from information_schema.INNODB_TRX;

-- 查看正在锁的事务
select * from information_schema.INNODB_LOCKS;

-- 查看等待锁的事务
select * from information_schema.INNODB_LOCK_WAITS;

-- 查看哪些表是打开（In_use，表示有多少线程正在使用某张表，Name_locked表示表名是否被锁）
SHOW OPEN TABLES;
14
-- 查看服务器当前隔离级别
SHOW VARIABLES LIKE '%transaction_isolation%';

-- 查看服务器当前隔离级别
SHOW VARIABLES LIKE 'tx_isolation%';

-- 查看服务器状态
SHOW STATUS LIKE '%lock%';

-- 查看超时时间
SHOW VARIABLES LIKE '%timeout%';

-- 查看当前执行的sql状态
select * from information_schema.PROCESSLIST p where p.state <> '';

-- 查询当前服务器支持的最大连接数
show variables like 'max_connections';

select version();
```

# 实践篇(37讲)

## 14|count(*)这么慢，我该怎么办

简单翻译一下：

1、COUNT(expr) ，返回SELECT语句检索的行中expr的值不为NULL的数量。结果是一个BIGINT值。
2、如果查询结果没有命中任何记录，则返回0
3、但是，值得注意的是，COUNT(*) 的统计结果中，会包含值为NULL的行数。

即以下表记录
create table #bla(id int,id2 int)
insert #bla values(null,null)
insert #bla values(1,null)
insert #bla values(null,1)
insert #bla values(1,null)
insert #bla values(null,1)
insert #bla values(1,null)
insert #bla values(null,null)

使用语句count(*),count(id),count(id2)查询结果如下：
select count(*),count(id),count(id2)
from #bla
results 7 3 2



