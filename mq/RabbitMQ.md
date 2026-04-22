



# RabbitMQ

## 版本
3.8.22


## 队列监控控制台
本地
http://localhost:15672/#/


## SpringBoot与RabbitMQ集成

```
spring:
  

 
  rabbitmq:
    host: 
    port: 5672
    username: 
    password:
	# 配置表示在 RabbitMQ 中创建了一个名为 test 的虚拟主机（Virtual Host/vhost）。这是一个逻辑隔离空间，在该空间下拥有独立的交换机、队列和权限设置，通常用于开发、测试环境的资源隔离。 
    virtual-host: test
    dynamic: false
    listener:
      # Routing 路由模型（交换机类型：direct）
      direct:
        #消息确认：手动签收
        acknowledge-mode: manual
        #当前监听容器数
        concurrency: 1
        #最大数
        max-concurrency: 10
        #是否支持重试
        retry:
          enabled: true
          #重试次数5,超过5次抛出异常
          max-attempts: 5
          #重试间隔 3s
          max-interval: 3000

```



