

# 算法设计

## 首要问题

`什么是算法优化建议？` 

`如何解决海量数据处理，存储问题？`

## 走近算法

### 常用算法介绍
我们日常编写程序时容易接触道德算法，包括先进先出算法，最近最少使用算法，最近最多使用算法等。
JDK中许多数据结构类的设计，缓存的实现都必须基于这些算法模型，才能让应用软件开发人员可以根据自己的软件业务逻辑选择合适的中间件或者数据结构。

#### FIFO算法

(First in First out)，即先进先出算法。

FIFO是其他队列的基础，FIFO也会影响到衡量QoS的关键指标：报文的丢弃，抖动，延时等。

在FIFO Cache设计中，核心原则就是：
`如果一个数据最先进入缓存中，则应该最早被淘汰`

在设计一个基于FIFO算法的缓存组件时，硬质迟疑下操作：
+ get(key) 
  如果Cache中存在该key，则返回对应的value值，否则，返回-1；
+ set(key, value) 
  如果Cache中存在该key，则重置value值；如果不存在该key，则将该key插入到Cache中，若Cache已满，则淘汰最早进入Cache的数据；

JDK自带的LinkedHashMap类是基于FIFO实现的，默认情况下LinkedHashMap就是按照添加顺序保存，我们只需重写下removeEldestEntry方法即可轻松实现一个FIFO缓存，简化版的实现代码如4-2所示
```java
///4-2 LinkedHashMap的FIFO实现
    final int cacheSize = 5;

    LinkedHashMap<Integer, String> lru = new LinkedHashMap<Integer, String>() {
        @Override
        protected boolean removeEldestEntry(Map.Entry<Integer, String> eldest){
            return size() > cacheSize;
        }
    };
```

FIFO关心的就是队列长度问题，队列长度会影响到报文时延，抖动，丢包率。