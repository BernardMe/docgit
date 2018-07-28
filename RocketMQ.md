




## 消息中间件需要解决哪些问题？
Publish/Subscribe
`发布/订阅`是消息中间件的最基本功能，也是相对于传统RPC通信而言



## 什么是Rocket

### 组成部分
name servers, brokers, producers and consumers

#### broker
broker是消息接收处理，落地的核心模块。这个模块用于接收producer发送的消息以及consumer


### RocketMQ重复发送
根据研究，RocketMQ是接收到`消费成功的标识`来标记消息是否消费的
如果没有收到`消费成功的标识`，则尝试重发

