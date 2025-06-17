[TOC]

# Oracle索引练习


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


## Oracle 给已经创建并且有数据的表中的 TIMESTAMP(6)类型字段加索引

### 关键注意事项
大表加索引的性能：
如果表数据量巨大（百万级以上），直接创建索引可能阻塞 DML 操作并消耗较多资源。
优化方案： 添加 ONLINE 选项允许并发 DML：
```sql
-- 在线创建索引（不阻塞DML）
-- CREATE INDEX STORE_CLERK_F_QVX_IDX_DELTIME ON STORE_CLERK_F_QVX (R_DEL_TIME) ONLINE;
```
建议优先使用 CREATE INDEX ... ONLINE 方案，确保生产环境操作最小化影响业务。

## 建立索引的目的：

 
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







