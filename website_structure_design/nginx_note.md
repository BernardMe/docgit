

## Nginx应用场景？
1 http服务器。
  Nginx是一个http服务可以独立提供http服务。可以做网页静态服务器。
2 虚拟主机
  可以实现在一台服务器虚拟出多个网站，例如个人网站使用的虚拟机。
3 反向代理，负载均衡
  当网站的访问量达到一定程度后，单台服务器不能满足用户的请求时，需要多台服务器集群可以使用nginx做反向代理。
4 nginx中也可以配置安全管理，比如可以使用nginx搭建API网关接口，对每个接口服务进行拦截。


## Nginx怎么处理请求的？
```xml
worker_processes	1;		# woker进程的数量
events {				# 事件区块开始
	worker_connections 1024;	# 每个worker支持的最多连接数
}					# 事件区块结束
http {					# HTTP区块开始
    include	    mime.types;		# NGINX支持的媒体文件库类型
    default_type    application/octet-stream;	# 默认的媒体类型
    sendfile	    on;			# 开启高效传输模式
    keepalive_timeout	65;		# 连接超时
    server {				# 第一个Server区块开始，表示一个独立的虚拟主机站点
	listen		80;		# 提供服务的端口，默认80
	server_name	localhost;	# 提供服务的域名主机名
	location / {			# 第一个location区块开始
		root	html;		# 站点的根目录，相当于Nginx的安装目录
		index	index.html;	# 默认的首页文件，多个用空格分开
	}				# 第一个location区块结束
	error_page 500502503504 /50x.html;	# 出现对应的状态码时，使用50x.html回应客户
	location = /50x.html {		# location区块开始，访问50x.html
		root	html;		# 指定对应的站点目录为html
	}
}
```
首先，Nginx在启动时，会解析配置文件，得到需要监听的端口与IP地址，然后在Nginx的master进程中先初始化好这个监控的Socket(创建Socket，设置addr，reuse等选项，绑定到指定的IP，端口上，再listen监听)
然后，在fork出多个子进程出来
之后，子进程会竞争accept新的链接。此时，客户端就可以向nginx发起连接了。当客户端与nginx进行三次握手，与nginx建立好一个链接后。此时，某一个子进程会accept成功，得到这个建立好连接的Socket，然后创建nginx对连接的封装，即ngx_connection_t结构体。
接着，设置读写事件处理函数，并添加读写事件来与客户端进行数据的交换。
最后，Nginx或客户端来主动断开连接。


## 配置

### 限流配置
Nginx的限流主要是两种方式：
限制访问频率(控制速率)
限制并发连接数(控制并发连接数)

1、漏桶算法(限制请求次数)
漏桶算法思路很简单，请求先进入到漏桶里，漏桶以固定的速度出水，也就是处理请求，当水加的过快，则会直接溢出，也就是拒绝请求，可以看出漏桶算法能强行限制数据的传输速率

实战：漏桶算法的基本配置
1、控制速率
①添加内容
vim /usr/local/nginx/conf/nginx.conf

在http中添加
limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;
limit_req_zone：用来限制单位时间内的请求数
$binary_remote_addr：定义限流对象，binary_remote_addr是一种key，表示基于 remote_addr(客户端IP) 来做限流，binary_ 的目的是压缩内存占用量。

③测试
访问页面，在一秒内快速刷新


2、令牌桶算法（限制请求速度）
对于很多场景来说，除了要求能够限制数据的平均传输速率外，还要求允许某种程度的突发传输。这时候漏桶算法可能就不合适了，令牌桶算法更为适合

3、计数器（限制连接数）
计数器比较简单粗暴，比如我们限制的是1s能够通过的请求数，实现的思路就是从第一个请求进来开始计时，在接下来的1s内，每个请求进来请求数就+1，超过最大请求数的请求会被拒绝，等到1s结束后计数清零，重新开始计数。
这种方式有个很大的弊端：比如前10ms已经通过了最大的请求数，那么后面的990ms的请求只能拒绝，这种现象叫做"突刺现象"

4、两种算法的区别
漏桶算法输入的时候请求不固定，但都会在漏桶里边先保存起来(小于漏桶的容量)，然后输出的时候采用的是恒定速率执行请求，有点像队列的先进先出，只是队列中的元素出队的时间间隔一致。
令牌桶算法跟漏桶算法刚好相反，令牌桶的大小就是接口所能承载的最大访问量，令牌的发放是恒速的，而最终能在某一时间处理的请求数不是恒定的，这取决于单位时间内令牌桶中的令牌数量。

从作用上来说，
漏桶和令牌桶算法最明显的区别就是是否允许突发流量(burst)的处理，漏桶算法能够强行限制数据的实时传输(处理)速度，对突发流量不做额外处理；
而令牌桶算法能够在限制数据的平均传输速率的同时允许某种程度的突发传输。

Nginx官方版本限制IP的连接和并发分别有两个模块：
limit_req_zone 用来限制单位时间内的请求数，即速率限制,采用的漏桶算法 "leaky bucket"。
limit_req_conn 用来限制同一时间连接数，即并发限制


### 代理配置
```xml
server {
        listen       8082;
        server_name  smartLink;

        charset utf-8;

        #access_log  logs/host.access.log  main;


		location / {
			root F:\X_Deployment\smartLink\webapp\dist;
			index index.html index.htm;
			try_files $uri /index.html;
		}

        #location / {
        #    proxy_pass        http://127.0.0.1:8000;
        #    proxy_set_header  X-Forwarded-Host   $host;
        #    proxy_set_header  X-Forwarded-Server $host;
        #    proxy_set_header  X-Real-IP        $remote_addr;
        #    proxy_set_header  X-Forwarded-For  $proxy_add_x_forwarded_for;
         #   proxy_http_version 1.1;
		#	root   html;
		#	index  index.html index.htm;
        #}

		location /manage/ {
            proxy_pass        http://127.0.0.1:8080/manage/;
            proxy_set_header  Host $http_host;
            proxy_set_header  X-Real-IP        $remote_addr;
            proxy_http_version 1.1;
        }


        #error_page  404             /index.html;
        #location = /index.html {
        #    root   /home/tools/weiwen/apache-tomcat-8.5.6/manage;
        #}


        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }

```

其中：
listen       8082; 代表监听8082端口
```xml
location /manage/ {
    proxy_pass        http://127.0.0.1:8080/manage/;
    proxy_set_header  Host $http_host;
    proxy_set_header  X-Real-IP        $remote_addr;
    proxy_http_version 1.1;
}
```
表示
在8082端口访问`/manage/`URL资源时，真实访问的是`http://127.0.0.1:8080/manage/`





