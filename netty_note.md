

# Netty

## 定义

### 本质
一个Jar包,一个NIO框架,是对 socket 网络编程的优秀包装

### 作用
既然netty 是对 socket 网络编程的优秀包装.那么在没有Netty之前,jdk强迫你必须用socket来写服务器，实际上是很繁琐的,缺乏一个高层次的api。然后Netty诞生了,他说，我来写jdk的socket，然后返回给你一个新的更简洁的api，你傻瓜式的就能写好一个网络服务器

### 好处
好处：提供异步的、事件驱动的网络应用程序框架和工具，你傻瓜式的就能写好一个网络服务器(当然是相对于更底层的socket 网络编程来说),通俗的说：一个好使的处理Socket的框架

### 支持多种协议
支持的协议有HTTP，WebSockets，SSL等。用Netty，你可以容易地利用Java NIO来提高服务端的性能。

### 场景：
阿里分布式服务框架 Dubbo 的 RPC 框架使用 Dubbo 协议进行节点间通信，Dubbo 协议默认使用 Netty 
作为基础通信组件，用于实现各进程节点之间的内部通信。
另外：
1 可以作为rpc的通信的框架远程过程的调用。
2 netty可以作为长连接的服务器基于websocket，实现客户端与服务器端长连接。
3 netty可以作为http服务器，类似jetty,tomcat



### 学习Netty需要的知识储备: 
Netty本身知识提供一种方便网络编程(特别是NIO)的框架(jar包),如果你熟悉TCP/IP,网络编程和NIO,那么Netty对你来说并不难,大概一周时间就可以使用.如果不熟悉以上这些,建议先熟悉以上技术,学习Netty时，核心要掌握它的线程模型

### 线程通信

:系统需要实现多进程通信，只有两种方式：内存共享、消息传递；分布式的系统间通信只有消息传递，Netty可作为应用间消息传递实现的基础组件，
Netty位于OSI协议栈的会话层、表示层、应用层都有涉及，这样你可以方便的扩展实现，处理会话层以上的协议和业务；
Netty封装了javanio的api，使之成为一个非常方便使用框架；
提供了提供处理IO的线程池，最重要的一点保证了一个socket处理在一个线程中完成，一个线程可以同时处理多个socket，



### Netty的一些重要概念

#### Channel
Channel, 表示一个连接，可以理解为每一个请求，就是一个Channel。
ChannelHandler，核心处理业务就在这里，用于处理业务请求。
ChannelHandlerContext，用于传输业务数据
ChannelPipeline，用于保存处理过程需要用到的ChannelHandler和ChannelHandlerContext

#### ByteBuf
ByteBuf是一个存储字节的容器，最大特点就是使用方便，它既有自己的读索引和写索引，方便你对整段字节缓存进行读写，也支持get/set，方便你对其中每一个字节进行读写，


####　Codec
Netty中的编码/解码器，通过他你能完成字节与pojo，pojo与pojo的相互转换，从而达到自定义协议的目的
在Netty里面最有名的就是HttpRequestDecoder和HttpResponseEncoder了。


### Netty实战

#### 用netty实现一个长连接

首先，我们需要用一个JavaBean来封装通信的协议内容，比如下面三个数据：

type: byte, 表示消息的类型，有心跳类型和内容类型

length：int，表示消息的长度

content：String， 表示消息的内容(心跳包在这里没有内容)






