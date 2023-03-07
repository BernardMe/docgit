-- 创建表结构
create table T(
id int primary key,
k int not null,
name varchar(16),
index (k)
)engine=InnoDB;

-- 插入测试数据
insert into T(id,k) values(100,1),(200,2),(300,3),(500,5),(600,6);

-- 如果语句是 select * from T where ID=500，即主键查询方式
SELECT t.* FROM t t WHERE ID = 500;

SELECT t.* FROM runner.t t
     WHERE ID = 500
     LIMIT 501;

-- 如果语句是 select * from T where k=5，即普通索引查询方式
select * from T where k = 5;

