-- 选中压力库
use million_pressure;
-- 创建表结构
create table dept(
    id int unsigned primary key auto_increment,
    deptno mediumint unsigned not null default 0,
    dname varchar(20) not null default '',
    loc varchar (13) not null default ''
)ENGINE=INNODB DEFAULT CHARSET=utf8mb4;

-- 创建部门表
create table emp(
    id int unsigned primary key auto_increment,
    empno mediumint unsigned not null default 0,
    ename varchar(20) not null default '',
    job varchar(9) not null default '',
    mgr mediumint unsigned not null default 0,
    hiredate date not null,
    sal decimal(7, 2) not null,
    comm decimal(7, 2) not null,
    deptno mediumint unsigned not null DEFAULT 0
)ENGINE=INNODB DEFAULT CHARSET=utf8mb4;


-- 2.开启二进制日志N
-- 查看二进制日志状态
show variables like 'log_bin_trust_function_creators';

-- set global log_bin_trust_function_creators=1;

-- 3、创建函数
-- 随机产生字符串
DELIMITER $$
CREATE FUNCTION rand_string(n INT) RETURNS VARCHAR(255)
BEGIN
 DECLARE chars_str VARCHAR(100) DEFAULT 'abcdefghijklmnopqrstuvwxyzABCDEFJHTJKLMNOPQRSTUVWXYZ';
 DECLARE return_str VARCHAR(255) DEFAULT '';
 DECLARE i INT DEFAULT 0;
 WHILE i < n DO
 SET return_str =CONCAT(return_str, SUBSTRING(chars_str, FLOOR(1+RAND()*52), 1));
 SET i = i + 1;
 END WHILE;
 RETURN return_str;
END $$

-- 随机产生部门编号
DELIMITER $$
CREATE FUNCTION rand_num() RETURNS INT(5)
BEGIN
 DECLARE i INT DEFAULT 0;
 SET i = FLOOR(100 + RAND()*10);
 RETURN i;
END $$

-- 4、创建存储过程
-- 1)向部门中插入数据过程
#执行存储过程,往dept表添加随机数据
DELIMITER $$
CREATE PROCEDURE insert_dept(IN START INT(10), IN max_num INT(10))
BEGIN
DECLARE i INT DEFAULT 0;
 SET autocommit=0;
 REPEAT
 SET i = i + 1;
 INSERT INTO dept(deptno, dname, loc) VALUES ((START+i), rand_string(10), rand_string(8));
 until i=max_num
 END REPEAT;
 COMMIT;
 END $$
END $$

-- 2)向员工表中插入数据过程
-- 插入员工表函数
delimiter $$
create procedure insert_emp(IN START INT(10), IN max_num int(10))
begin
    declare i int default 0;
    set autocommit=0;
    repeat
    set i=i+1;
    insert into emp(empno, ename, job, mgr, hiredate, sal, comm, deptno) values((start+i), rand_string(6), 'SALESMAN', 0001, CURDATE(), 2000, 400, rand_num());
    until i=max_num
    end repeat;
    commit;
end$$

-- 5 调用上面两个插入函数
-- 在部门表中插入数据
call insert_dept(100, 10);
-- 在员工表中插入50W数据
call insert_emp(100001, 500000);
