



# 规范

## 来源

在介绍activemq之前，先简单介绍JMS，它是J2EE的13个规范之一，提供的是消息中间件的规范。



## JMS规范


### 基本组成

JMS包括以下基本构件：

　　　连接工厂，是客户用来创建连接的对象，ActiveMQ提供的是ActiveMQConnectionFactory；

　　　连接connection；

　　　会话session，是发送和接收消息的上下文，用于创建消息生产者，消息消费者，相比rocketMQ会话session是提供事务性的；

　　　目的地destination，指定生产消息的目的地和消费消息的来源对象；

　　　生产者、消费者，由会话创建的对象，顾名思义。



### 消息通信机制

点对点模式，每个消息只有1个消费者，它的目的地称为queue队列；

发布/订阅模式，每个消息可以有多个消费者，而且订阅一个主题的消费者，只能消费自它订阅之后发布的消息


### 　消息确认机制

　　　Session.AUTO_ACKNOWLEDGE，直接使用receive方法。
　　　Session.CLIENT_ACKNOWLEDGE，通过消息的acknowledge 方法确认消息。
　　　Session.DUPS_ACKNOWLEDGE，该选择只是会话迟钝第确认消息的提交。如果JMS provider 失败，那么可能会导致一些重复的消息。如果是重复的消息，那么JMS provider 必须把消息头的JMSRedelivered 字段设置为true






## 知识点


### 

Queues:是队列方式消息

Topics:是主题方式消息

Subscribers:消息订阅监控查询

Connections:可以查看链接数，分别可以查看xmpp、ssl、stomp、openwire、ws和网络链接

Network:是网络链接数监控

Send:可以发送消息数据


### 消息中间件构建要素

Broker
消息服务器，为server提供消息核心服务

Producer
消息生产者，业务的发起方，负责生产消息传输给broker

Consumer
消息消费者，业务的处理方，负责从broker获取消息并进行业务逻辑处理

Topic
主题，发布订阅模式下的消息统一汇集地，不同生产者向topic发送消息，由MQ服务器分发到不同的订阅者，实现消息的广播

Queue
队列，PTP模式下，特定生产者向特定queue发送消息，消费者订阅特定的queue完成指定消息的接收

Message
消息体，根据不同通信协议定义的固定格式进行编码的数据包，来封装业务数据，实现消息的传输



### 消息中间件模式运行模式

####  点对点模式
消息生产者生产消息发送到queue中，消息消费者从queue中取出并且消费消息。Queue支持存在多个消费者，但是每一个消息，只会有一个消费者可以消费，此消息消费后，队里queue便不再存储

#### 消费订阅模式

topic实现了发布和订阅，当你发布一个消息，所有订阅这个topic的服务都能得到这个消息。


