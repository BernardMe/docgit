



## ES中数据结构

详细解释
您可以将 Elasticsearch 的数据层次结构与关系型数据库进行类比，这有助于理解：

Elasticsearch					关系型数据库 (如 MySQL)
索引							数据库
~~类型~~ (已在 7.x+ 版本中废弃)	表
文档							一行记录
字段							一列
从这个类比可以看出：

关系型数据库中，操作的基本单位是“一行记录”。

在 Elasticsearch 中，操作的基本单位就是“一个文档”。

文档是什么？

1 JSON对象
一个文档就是一个JSON对象，它包含了实际的数据；

2 可被索引
这个JSON里面的字段(键值对)会被ElasticSearch分析和索引，以便后续进行高效的搜索；

3 唯一标识
每个文档存储在一个索引下，并且有一个唯一的`_id`标识它；

示例文档：
```json
{
	"_index": "products", //它属于那个索引
	"_id": "1",				//它的唯一id
	"_source": {			//文档的真实内容(你存入的json数据)
		"name": "无线蓝牙耳机",
		"price": 299.00,
		"description": "主动降噪，长续航",
		"category": "电子产品",
		"in_stock": true
	}
}
```
对于现代 Elasticsearch，我更推荐这样的理解：

```
# MySQL 数据库
数据库(Database)	->表(Table) ->行(Row) ->列(Column)

# Elasticsearch
索引(Index) -> 文档(Document) ->字段(Field)
```



## 增删改查
以下是在 Elasticsearch（ES）中对文档和索引的增删改查操作示例：



1 增加文档

2 删除文档

3 修改文档

4 查询文档
