


# 背景

## 怎么理解 IaaS、SaaS 和 PaaS 的区别？
如果你是一个网站站长，想要建立一个网站。不采用云服务，你所需要的投入大概是：买服务器，安装服务器软件，编写网站程序。现在你追随潮流，采用流行的云计算，如果你采用IaaS服务，那么意味着你就不用自己买服务器了，随便在哪家购买虚拟机，但是还是需要自己装服务器软件而如果你采用PaaS的服务，那么意味着你既不需要买服务器，也不需要自己装服务器软件，只需要自己开发网站程序如果你再进一步，购买某些在线论坛或者在线网店的服务,这意味着你也不用自己开发网站程序，只需要使用它们开发好的程序，而且他们会负责程序的升级、维护、增加服务器等，而你只需要专心运营即可，此即为SaaS。



## 如何通俗解释Docker是什么？

Docker的思想来自于集装箱，集装箱解决了什么问题？在一艘大船上，可以把货物规整的摆放起来。并且各种各样的货物被集装箱标准化了，集装箱和集装箱之间不会互相影响。那么我就不需要专门运送水果的船和专门运送化学品的船了。只要这些货物在集装箱里封装的好好的，那我就可以用一艘大船把他们都运走。
docker就是类似的理念。现在都流行云计算了，云计算就好比大货轮。docker就是集装箱。
1.不同的应用程序可能会有不同的应用环境，比如.net开发的网站和php开发的网站依赖的软件就不一样，如果把他们依赖的软件都安装在一个服务器上就要调试很久，而且很麻烦，还会造成一些冲突。比如IIS和Apache访问端口冲突。这个时候你就要隔离.net开发的网站和php开发的网站。常规来讲，我们可以在服务器上创建不同的虚拟机在不同的虚拟机上放置不同的应用，但是虚拟机开销比较高。docker可以实现虚拟机隔离应用环境的功能，并且开销比虚拟机小，小就意味着省钱了。
2.你开发软件的时候用的是Ubuntu，但是运维管理的都是centos，运维在把你的软件从开发环境转移到生产环境的时候就会遇到一些Ubuntu转centos的问题，比如：有个特殊版本的数据库，只有Ubuntu支持，centos不支持，在转移的过程当中运维就得想办法解决这样的问题。这时候要是有docker你就可以把开发环境直接封装转移给运维，运维直接部署你给他的docker就可以了。而且部署速度快。
3.在服务器负载方面，如果你单独开一个虚拟机，那么虚拟机会占用空闲内存的，docker部署的话，这些内存就会利用起来。

总之docker就是集装箱原理。


## 容器的本质到底是什么

容器的本质是进程。容器，就是未来云计算系统中的进程；容器镜像就是这个系统里的".exe"安装包。
K8s就是操作系统！


## Docker基础操作

查看容器名
docker ps -a


构建镜像
docker build -t 镜像+tag .


启动交互式容器
docker run -i -t IMAGE /bin/bash


以守护形式运行容器
docker run -i -t IMAGE /bin/bash

	退出 Ctrl+P Ctrl+Q

启动守护式容器
docker run -d 容器名


启动docker容器，-d表示后台启动 -p表示做端口的映射 把容器里面的80端口映射到宿主机的81端口，使用镜像为httpd
docker run -d -p 81:80 httpd


查看容器信息
docker inspect 容器名


附加到运行中的容器
docker attach 容器名


在容器中启动进程
docker exec [-d][-i][-t] 容器名 [COMMAND] [ARGS...] 


查看容器日志
docker logs [-f][-t][--tail] 容器名


停止守护式容器
docker stop 容器名 发送信号到容器 等待容器停止

docker kill 容器名 直接停止容器


删除已停止的容器
docker rm 容器名







## Docker 的核心组件包括：

Docker 客户端

Docker 服务器

Docker 镜像

Docker 容器

registry



### Docker 服务器

Docker daemon 是服务器组件，以Linux后台服务的方式运行


### Docker删除名称为none的Image镜像

把所有的docker ps -a里面Exited的都删除，然后再开始rmi…..

docker ps -a | grep "Exited" | awk '{print $1 }'|xargs docker stop

docker ps -a | grep "Exited" | awk '{print $1 }'|xargs docker rm

docker images|grep none|awk '{print $3 }'|xargs docker rmi




### docker daemon远程连接设置详解

默认配置下，Docker daemon 只能响应来自本地 Host 的客户端请求。如果要允许远程客户端请求，需要在配置文件中打开 TCP 监听，
步骤如下：

Centos7：

/etc/docker/daemon.json会被docker.service的配置文件覆盖，直接添加daemon.json不起作用。可以有如下几种设置：

1、直接编辑配置文件：Centos中docker daemon配置文件在/lib/systemd/system/docker.service，找到以下字段，在后面添加如下，注意，此处不能用"fd：//",否则报错
```
... 
[Service] 
... 
ExecStart=/usr/bin/dockerd -H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375
```	
执行
```
systemctl daemon-reload 
systemctl restart docker.service
```

### Docker 镜像

本节讨论 base 镜像。

base 镜像有两层含义：

不依赖其他镜像，从 scratch 构建。

其他镜像可以之为基础进行

可以看到，新镜像是从 base 镜像一层一层叠加生成的。每安装一个软件，就在现有镜像的基础上增加一层。

问什么 Docker 镜像要采用这种分层结构呢？

最大的一个好处就是 - 共享资源。

这时可能就有人会问了：如果多个容器共享一份基础镜像，当某个容器修改了基础镜像的内容，比如 /etc 下的文件，这时其他容器的 /etc 是否也会被修改？

答案是不会！
修改会被限制在单个容器内。
这就是我们接下来要学习的容器 Copy-on-Write 特性。


#### 可写的容器层

当容器启动时，一个新的可写层被加载到镜像的顶部。
这一层通常被称作“容器层”，“容器层”之下的都叫“镜像层”。

`只有容器层是可写的，容器层下面的所有镜像层都是只读的。`


## docker常见错误

### docker端口映射或启动容器时报错Error response from daemon: driver failed programming external connectivity on endpoint quirky_allen

原因:

docker服务启动时定义的自定义链DOCKER由于某种原因被清掉
重启docker服务及可重新生成自定义链DOCKER

解决:

重启docker服务后再启动容器
systemctl restart docker
docker start foo

