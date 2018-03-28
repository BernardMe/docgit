

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

### 学习Netty需要的知识储备: 
Netty本身知识提供一种方便网络编程(特别是NIO)的框架(jar包),如果你熟悉TCP/IP,网络编程和NIO,那么Netty对你来说并不难,大概一周时间就可以使用.如果不熟悉以上这些,建议先熟悉以上技术,学习Netty时，核心要掌握它的线程模型

### 线程通信

:系统需要实现多进程通信，只有两种方式：内存共享、消息传递；分布式的系统间通信只有消息传递，Netty可作为应用间消息传递实现的基础组件，
Netty位于OSI协议栈的会话层、表示层、应用层都有涉及，这样你可以方便的扩展实现，处理会话层以上的协议和业务；Netty封装了java
 
nio的api，使之成为一个非常方便使用框架；提供了提供处理IO的线程池，最重要的一点保证了一个socket处理在一个线程中完成，一个线程可以同时处理多个socket，