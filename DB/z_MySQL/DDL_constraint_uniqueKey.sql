-- ## mysql中int、bigint、smallint 和 tinyint的区别与长度
-- 1、在mysql 命令行创建如下表

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


-- 2、desc
desc test_int_1;


## 查看最大连接数
show variables like '%max_connections%';


