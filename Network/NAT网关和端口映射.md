

# 原理性概念

## 端口映射原理

`内网的一台电脑要上因特网，就需要端口映射 `

### 端口映射分为动态和静态 

动态端口映射:
内网中的一台电脑要访问新浪网，会向NAT网关发送数据包，包头中包括对方(就是新浪网)IP、端口和本机IP、端口，NAT网关会把本机IP、端口替换成自己的公网IP、一个未使用的端口，并且会记下这个映射关系，为以后转发数据包使用。然后再把数据发给新浪网，新浪网收到数据后做出反应，发送数据到NAT网关的那个未使用的端口，然后NAT网关将数据转发给内网中的那台电脑，实现内网和公网的通讯.当连接关闭时，NAT网关会释放分配给这条连接的端口，以便以后的连接可以继续使用。 
`态端口映射其实就是NAT网关的工作方式。 `

静态端口映射: 
就是在NAT网关上开放一个固定的端口，然后设定此端口收到的数据要转发给内网哪个IP和端口，不管有没有连接，这个映射关系都会一直存在。就可以让公网主动访问内网的一个电脑 
NAT网关可以是交换机、路由器或电脑。 
现在很多关于端口映射的文章都严重的误导人，许多不懂的人把端口映射软件用在自己的电脑上，其实`端口映射是要在网关上做的！！！`而网关很少是电脑，大部分人也不能控制网关，所以那几个端口映射的软件基本没用。 


### 什么是内网、内网TrueHost、什么是公网、什么是NAT　 

公网、内网是两种Internet的接入方式。 

	内网接入方式：上网的计算机得到的IP地址是Inetnet上的保留地址，保留地址有如下3种形式： 
　　　　10.x.x.x 
　　　　172.16.x.x至172.31.x.x 
　　　　192.168.x.x 
	内网的计算机以NAT（网络地址转换）协议，通过一个公共的网关访问Internet。内网的计算机可向Internet上的其他计算机发送连接请求，但Internet上其他的计算机无法向内网的计算机发送连接请求。

	公网接入方式：上网的计算机得到的IP地址是Inetnet上的非保留地址。公网的计算机和Internet上的其他计算机可随意互相访问。  

	NAT（Network Address Translator）是网络地址转换，它实现内网的IP地址与公网的地址之间的相互转换，将大量的内网IP地址转换为一个或少量的公网IP地址，减少对公网IP地址的占用。NAT的最典型应用是：在一个局域网内，只需要一台计算机连接上Internet，就可以利用NAT共享Internet连接，使局域网内其他计算机也可以上网。使用NAT协议，局域网内的计算机可以访问Internet上的计算机，但Internet上的计算机无法访问局域网内的计算机。

　　	Windows操作系统的Internet连接共享、sygate、winroute、unix/linux的natd等软件，都是使用NAT协议来共享Internet连接。 
	所有ISP（Internet服务提供商）提供的内网Internet接入方式，几乎都是基于NAT协议的。 
