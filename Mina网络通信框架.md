Mina网络通信框架





## 什么是MINA
Apache MINA(Multipurpose Infrastructure for Network Applications，多用途基础设施for网络应用)是一个网络应用框架，可以帮助我们开发高性能和高扩展性的网络应用。它通过封装Java NIO提供了一个支持各种传输协议（如：TCP/IP和UDP/IP）的抽象事件驱动异步API

`Mina是对Java NIO框架进行了一层封装的Socket类库`


`Apache MINA自带了许多子项目： 
异步http服务 
ftp服务 
一个支持ssh协议的java库 
XMPP服务
`

Mina框架主页： 
https://mina.apache.org/ 
Mina框架下载地址： 
https://mina.apache.org/downloads-mina.html


## 为什么使用Mina?

### 传统socket：阻塞式通信
每建立一个Socket连接时，同时创建一个新线程对该Socket进行单独通信（采用阻塞的方式通信）。这种方式具有很高的响应速度，并且控制起来也很简单，在连接数较少的时候非常有效，但是如果对每一个连接都产生一个线程的无疑是对系统资源的一种浪费，如果连接数较多将会出现资源不足的情况。

### nio：非阻塞通信
nio设计背后的基石：反应器模式，用于事件多路分离和分派的体系结构模式

反应器模式的核心功能如下： 
将事件多路分用 
将事件分派到各自相应的事件处理程序

NIO 的非阻塞 I/O 机制是围绕 `选择器`和 `通道`构建的
Channel类表示服务端和客户机之间的一种通信机制。
Selector类是Channel的多路复用器。

Selector 类将`传入的客户机请求` 多路复用，并将它们分派到各自的的请求处理程序


#### 简单的来说：NIO是一个基于事件的IO架构
最基本的思想就是：有事件我通知你，你再去做你的事情。而且NIO的主线程只有一个，不像传统的模型，需要多个线程以应对客户端请求，也减轻了JVM的工作量


Channel必需要注册到Selector
Channel注册至Selector以后，

#### `经典的调用方法`如下
nio中取得事件通知，就是在selector的select事件中完成的。
在selector事件时有一个线程向操作系统询问，
selector中注册的Channel&&SelectionKey的键值对的各种事件是否有发生，
如果有则添加到selector的selectedKeys属性Set中去，并返回本次有多少个感兴趣的事情发生
如果发现这个值>0，表示有事件发生，马上迭代selectedKeys中的selectionKey，根据key中表示的事件，来做相应的处理
实际上，这段说明表明了异步socket的核心，即异步socket不过是将多个socket的调度(或者还有他们的线程调度)全部交给操作系统自己去完成，异步的核心Selectot，不过是将这些调度收集，分发而已。



使用Mina框架实现C/S通讯




## Mina的使用

你只需要关心你要发送、接收的数据以及你的业务逻辑即可。同样的，无论是哪端，Mina 的执行流程如下所示：
(1.) IoService：这个接口在一个线程上负责套接字的建立，拥有自己的Selector，监听是否有连接被建立。
(2.) IoProcessor：这个接口在另一个线程上，负责检查是否有数据在通道上读写，也就是说它也拥有自己的Selector，这是与我们使用JAVA NIO 编码时的一个不同之处，通常在JAVA NIO 编码中，我们都是使用一个Selector，也就是不区分IoService与IoProcessor 两个功能接口。另外，IoProcessor 负责调用注册在IoService 上的过滤器，并在过滤器链之后调用IoHandler。
(3.) IoFilter：这个接口定义一组拦截器，这些拦截器可以包括日志输出、黑名单过滤、数据的编码（write 方向）与解码（read 方向）等功能，其中数据的encode 与decode是最为重要的、也是你在使用Mina 时最主要关注的地方。
(4.) IoHandler：这个接口负责编写业务逻辑，也就是发送，接收数据的地方。





## 其他

Socket 网络编程基于一个线程对应一个客户端的实现方式，大量的线程创建和销毁导致性能下降，无法应对高并发量的访问，所以基于服务器端的网络通信开发，我们常用 Mina 网络通信框架


首先，我们来看看 Mina 的几个重要接口：

•IoServiece ：
这个接口在一个线程上负责套接字的建立，拥有自己的 Selector，监听是否有连接被建立。
这个接口是服务端IoAcceptor、客户端IoConnector 的抽象

•IoProcessor ：这个接口在另一个线程上负责检查是否有数据在通道上读写，也就是说它也拥有自己的 Selector，这是与我们使用 JAVA NIO 编码时的一个不同之处，通常在 JAVA NIO 编码中，我们都是使用一个 Selector，也就是不区分 IoService与 IoProcessor 两个功能接口。另外，IoProcessor 负责调用注册在 IoService 上的过滤器，并在过滤器链之后调用 IoHandler。  

•IoAccepter ：
这个接口是TCPServer 的接口。主要增加了void bind()监听端口、void unbind()解除对套接字的监听等方法。
IoAcceptor 可以多次调用bind()方法（或者在一个方法中传入多个SocketAddress 参数）同时监听多个端口。
相当于网络应用程序中的服务器端

•IoConnector ：
这个接口是TCPClient 的接口， 主要增加了ConnectFuture connect(SocketAddressremoteAddress,SocketAddress localAddress)方法，用于与Server 端建立连接，
相当于客户端

•IoSession ：当前客户端到服务器端的一个连接实例

•IoHandler ：这个接口负责编写业务逻辑，也就是接收、发送数据的地方。这也是实际开发过程中需要用户自己编写的部分代码。

•IoFilter ：过滤器用于悬接通讯层接口与业务层接口，这个接口定义一组拦截器，这些拦截器可以包括日志输出、黑名单过滤、数据的编码（write 方向）与解码（read 方向）等功能，其中数据的 encode与 decode是最为重要的、也是你在使用 Mina时最主要关注的地方。





