


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
