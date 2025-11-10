



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


## ES中aggregation(聚合) 和 nativesearchquery(原生搜索查询) 区别

在Elasticsearch（ES）中，`aggregation`和`NativeSearchQuery`是两种不同层面的概念，服务于不同的目的。
`NativeSearchQuery`通常指代使用Elasticsearch原生API进行的查询操作，而`aggregation`则是这些查询操作中用于数据分析和统计的一种特殊功能。
以下是它们之间的主要区别：

1. 概念和目的
特性 	Aggregation（聚合）	NativeSearchQuery（原生搜索查询）
目的	主要是为了分析和统计数据，而非检索具体的文档。它将匹配搜索条件的文档进行分组，并对这些组进行计算，以生成数据的摘要、统计信息或分析结果。	主要是为了检索和匹配特定的文档。它根据用户定义的查询条件（如关键词、范围、布尔逻辑等）来查找并返回相关的文档。
返回结果	返回的是结构化的分析结果，例如每个分组的计数、平均值、总和等，而不是原始文档列表。返回的是匹配查询条件的文档列表，通常包括文档的元数据和相关性得分。
类比	类似于SQL中的`GROUP BY`、`SUM`、`AVG`、`COUNT`等操作。	类似于SQL中的`SELECT`语句。
查询范围	聚合可以基于整个数据集运行，也可以基于通过查询（query）和过滤（filter）操作筛选出的文档子集来运行。	本身就定义了搜索的范围，即哪些文档应该被考虑。
典型用途	数据可视化（如Kibana仪表盘）、统计分析、趋势洞察（例如，“过去7天内每种产品类别的销售额是多少？”）。	搜索引擎功能、精确匹配、模糊查询、全文搜索（例如，“搜索所有包含‘Elasticsearch’关键字的文档”）。

2. 在查询请求中的关系
在Elasticsearch的搜索API中，`aggregation`和`query`是平级的参数，但通常是协同工作的。一个典型的搜索请求JSON结构如下： 
```
POST /your_index/_search
{
  "size": 0,
  "query": {
    "match": {
      "field": "your_search_term"
    }
  },
  "aggs": {
    "your_aggregation_name": {
      "terms": {
        "field": "your_grouping_field"
      }
    }
  }
}

```

## 增删改查
以下是在 Elasticsearch（ES）中对文档和索引的增删改查操作示例：



1 增加文档

2 删除文档

3 修改文档

4 查询文档
