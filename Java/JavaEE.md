
# Tomcat

## 【Tomcat】JVM，Tomcat，Servlet，Tomcat中的应用。彻底弄懂这些概念之间的联系

tomcat和tomcat中的应用（即webapps下的war包）是运行在同一个JVM中的，只是分工不同
`tomcat的角色是“调度员”，而你的应用的角色是“工作者”，`
tomcat处理一个请求的大致过程如下：
1. 假设tomcat监听8080端口，当一个http请求从主机的8080端口发送过来时，tomcat最先获知。
2. tomcat将此请求作为任务加入一个队列中，jvm中有若干工作者线程会从这个队列中获取任务。
3. 假设工作线程A取到了这个任务，那么线程A通过分析请求的url，检查已加载的web.xml配置，来判断此请求应该交给应用的哪个servlet处理(假设应用是用Servlet实现的)
4. 工作线程A调用对应的Serlvet的方法(service/get/post等)，把请求封装成request对象传给servlet
5. 此时应用开始干活(实际上干活的还是工作线程，只不过执行的是应用中编写的业务逻辑)，解析请求参数，处理业务流程，生成response
6. 工作线程A把response回送给请求的发送端

`servlet规范就是规范了应用和容器的通信`
简单地说，比如你用SpringMVC写了一个web应用，springMVC是遵守servlet规范的，所以，它可以跑在任何遵循servlet规范的容器上，tomcat就是一个遵循servlet规范的容器，当然也可以跑在jetty上

tomcat是用java语言开发的，所以，tomcat就是一个java应用，需要跑在jvm上


## 目录结构

- bin 可执行命令
- conf 配置文件
    + server.xml tomcat配置文件
    + web.xml 对所有project配置信息
- lib 库文件
    + server-api.jar Servlet相关信息
    + jsp-api.jar JSP相关信息
- logs 存放日志文件
- temp 存放临时文件
- webapps 存放所有的web项目(应用)，以文件夹的形式存放
- work tomcat 工作目录

## 部署项目

- WEB-INF 客户端访问不到
    + classes
    + lib
    + web.xml 该应用自身的配置文件

## HTTP协议

分为请求部分和响应部分

### 请求部分
- 请求行(第一行)
    + 请求方式 GET POST
    + 资源路径 
    + 协议版本号 HTTP1.1
- 请求头(第二行开始，到第一个空行结束)
    + Accept 浏览器可接受的MIME类型
    + Accept-Charset 浏览器可接受的字符集
    + Accept-Encoding 浏览器能够进行解码的数据编码格式，gzip
    + Accept-Language 浏览器所希望的语言种类
    + Host 初始URL中主机和端口号
    + *User-Agent 浏览器类型
    + *Referer 包含一个URL，用户从该URL代表的页面出发访问当前请求的页面
- 请求实体(从第一个空行开始，到最后)
    + 携带post方式提交时的数据

### 响应部分
- 响应行(第一行)
    + 协议版本号
    + 状态码 字头: 1-消息 2-成功 3-重定向 4-请求错误 5-服务器错误
    + 状态码描述信息
- 响应头(第二行开始，到第一个空行结束)
	+ Allow 服务器支持哪些请求方式
	+ Server 处理请求的原始服务器的软件信息
	+ *Location 是一个URL，重定向时使用，表示客户端应该到哪里去提取文档
	+ Refresh 告诉浏览器过n秒后刷新
	+ *Content-Type 表示响应实体文档属于什么MIME类型
	+ Content-Length 返回的实体内容的长度
	+ Last-Modified 文档的最后改动时间 
	+ Content-Location 实体所在的实际位置路径
- 响应实体(第一个空行开始到最后)
    + 就是访问页面的源码


## 请求和响应

# 接口Servlet

web服务器习惯处理静态页面，所以需要一个程序来帮忙处理动态请求(如当前时间)。Web服务器程序会将动态请求转发给帮助程序，帮助程序处理后，返回处理后的静态结果给web服务器程序。这样就避免了web服务器程序处理动态页面。Servlet的本质是一个帮助程序。如下图
![servet](servlet.png)

Servlet工作流程分为三个阶段。init(初始化)，service(运行)，destroy(销毁)Servlet没有main方法，所有行为由Container控制。Container就是一个java程序。在加载Servlet的.class后，Servlet会由构造函数生成一个实例，然后Container调用init()方法完成参数的初始化，接着调用service()方法，service会根据网页的请求，调用doGet或者doPost方法，最后调用销毁方法。整个流程如下图：
![servlet_life](servlet_life.png)

## 类GenericServlet
public abstract class GenericServl etextends Object implements Servlet, ServletConfig, Serializable

## 类HttpServlet
public abstract class HttpServlet extends GenericServlet implements Serializable

继承了GenericServlet，是一个专门给HTTP提供的Servlet

### 奇怪的两个service方法
- public void service(ServletRequest req, ServletResponse res) 方法是重写的其父类GenericServlet类的方法，这个方法是公共的（public），其作用是接受客户端的请求并将其传递给service(HttpServletRequest, HttpServletResponse)方法
- protected void service(HttpServletRequest req, HttpServletResponse resp) 方法是HttpServlet类定义的方法，是受保护的（protected），主要作用是接受标准的Http请求（HttpServletRequest），并根据请求方式不同分发到不同的doXXX(HttpServletRequest, HttpServletResponse)方法
- 这就是HttpServlet有两个service方法的原因了。
    + 一般情况下我们的Servlet只需重写受保护的service方法就够了，不分发直接处理
    + 或者重写doGet和doPost方法
- 否则就报`405错误`

## 405问题
请求行中指定的请求方法不能被用于请求相应的资源。
该响应必须返回一个Allow头信息用以表示出当前资源能够接受的请求方法的列表。

HTTP 405  错误– 方法不被允许(Method not allowed). 
一般某个 URL 只允许用 GET 访问，然后你用 POST 就会 405，
只要调用父类(HttpServlet)中的doGet，doPost方法，就会 405
`所以，只要想办法不让tomcat调用HttpServlet的doGet，doPost方法，就避免了405问题`

## Servlet接口定义

javax.servlet.Servlet 接口定义了 Servlet 必须实现的 5 个方法：

destroy ：Servlet 容器卸载 Servlet 时调用此方法释放 Servlet 占用的资源；
getServletConfig ：返回 Servlet 配置信息，如初始化和启动参数等；
getServletInfo ：返回 Servlet 信息，如作者、版本等；
init ：Servlet 容器调用此方法初始化 Servlet；
service ：Servlet 容器调用此方法处理客户端请求。

## 如何使用Servlet完成服务器端编程(Servlet 实现)

可以通过继承 javax.servlet.GenericServlet 或者 javax.servlet.http.HttpServlet 来实现自己的 Servlet 程序。

GenericServlet 抽象类实现了 Servlet 和 ServletConfig 接口，定义了生命周期的 init 方法和 destroy 方法，与应用层协议无关。继承 GenericServlet 类型后，只需要实现 service 方法即可。

HttpServlet 抽象类继承了 GenericServlet 类型，在 service 方法中把标准 HTTP 请求分发到相应的 doXXX 方法进行处理。HttpServlet 的子类必须覆盖 doGet、doPost、doPut、doDelete、init、destroy 或者 getServletInfo 方法中的一个或多个。

由于 Servlet 通常运行在多线程的容器中，因此在 Servlet 中处理客户端请求时必须考虑共享资源的同步互斥问题。

## Servlet 与 Tomcat 的交互

Servlet 的生命周期由 Tomcat 负责管理。在 Tomcat 启动时，读取 web.xml 中配置的 Servlet 配置生成 ServletConfig 对象，然后加载 Servlet 的实现类，创建 Servlet 的实例，再调用 init 方法传入 ServletConfig 对象完成初始化。Servlet 的 init 方法在整个生命周期中只被调用一次。

Tomcat 调用 Servlet 处理 http 请求的过程可以用下图表示。每次 Tomcat 接收到一个 Servlet 请求时，会产生一个新的线程，创建 HttpServletRequest 实例 request 和 HttpServletResponse 实例 response，然后调用 service 方法并传入 request、response 实例来处理客户端请求。

在 service 方法中，Servlet 能够读取 request 中的请求参数，处理完后把相应的返回内容设置到 response 中。service 方法返回后，Tomcat 再根据 response 的内容，返回给客户端。

![servlet_in_tomcat](servlet_in_tomcat.jpg)

当 Tomcat 关闭或重启时，需要卸载 Servlet，这时调用 Servlet 的 destroy 方法，释放 Servlet 占用的资源，然后退出。destroy 方法只能调用一次，调用之后 Servlet 对象就可以被 GC 回收。

## 单例模式

### 饿汉式
- 私有化构造器
- 定义一个静态成员变量，直接创建对象进行赋值
- 对外提供一个公开，静态的方法用于获取实例对象

#### 优缺点
- 优点
    + 通过静态成员变量，只加载一次的策略，保证了单例。
    + 代码简单易懂
- 缺点
    + 容易创建多余的单例对象

### 懒汉式单例
- 私有化构造器
- 定义一个静态成员变量，初始化为null
- 对外提供一个公开，静态的方法用于获取实例对象
- 第一次调用方法时，实例化对象赋值静态成员变量

#### 优缺点
- 优点
    + 静态成员变量第一次调用方法时，创建对象，避免了多余的单例对象
- 缺点
    + 代码复杂

## Servlet的生命周期

### Servlet是单实例多线程的
- 载入 第一个请求的时候创建Servlet对象，只创建一次
- 初始化 调用init方法，只执行一次
- 执行 每请求一次，就执行一次service方法
- 销毁 销毁servlet前会调用destroy方法

## Servlet加载模式
Servlet默认是懒汉单例模式，
可以通过配置load-on-startup标签调整为饿汉单例模式。该标签需要一个整数，如果该数字是一个负数，相当于没有配置；如果是正整数或0，那么数字越小越优先被加载(实例化和初始化)，因为有一些默认的Servlet需要优先加载，自定义的servlet需要在其后面再加载，配置数字最小从5开始

## Servlet成员变量的问题
在Servlet中，尽量不要使用成员变量，因为在多线程的时候，会导致线程安全问题，最好使用局部变量

# Servlet中常用的对象

## 接口HttpServletRequest
- 继承了SevletRequest接口
- 为Servlet提供了客户端的请求信息，由Servlet容器创建后，作为参数传递给service方法
- 通过该对象，Servlet可以获取到请求行，请求头，请求实体

### 获取请求行信息
- getMethod 获取请求方式
- getProtocol 获取协议版本号
- getScheme 获取协议
- getRequestURL 获取请求URL路径
- getRequestURI 获取请求URI路径
- getQueryString 获取GET方式的路径后面的查询字符串

### 获取请求头信息
- getHeader 通过名称获取请求头信息
- getHeaderNames 获取所有请求头信息

### 获取请求实体
- getParameter 获取只有一个值的参数
- getParameterValues 获取数组参数

### 获取其他信息
- getxxx

### 基于request.getAttribute与request.getParameter的区别详解
`HttpServletRequest接口`既有getAttribute()方法，也有getParameter()方法，这两个方法有以下区别：
1、`HttpServletRequest接口`有setAttribute()方法，而没有setParameter()方法；

2、当两个Web组件之间为`链接关系`时，被链接的组件通过getParameter()方法来获得请求参数；
例如，假定welcome.jsp和authenticate.jsp之间为链接关系，welcome.jsp中有以下代码：
```html
<a href="authenticate.jsp?username=qianyunlai.com">authenticate.jsp </a>  
 //或者:  
 <form name="form1" method="post" action="authenticate.jsp">  
     请输入用户姓名:<input type="text" name="username">  
     <input type="submit" name="Submit" value="提交">  
 </form> 
 ```
在authenticate.jsp中通过request.getParameter(“username”)方法来获得请求参数username:
`<% String username=request.getParameter("username"); %>`

3、当两个Web组件之间为`转发关系`时，转发目标组件通过getAttribute()方法来和转发源组件共享request范围内的数据。
假定authenticate.jsp和hello.jsp之间为转发关系。authenticate.jsp希望向hello.jsp传递当前的用户名字，如何传递这一数据呢？先在authenticate.jsp中调用setAttribute()方法：
```html
<%  
    String username=request.getParameter("username");  
    request.setAttribute("username",username);  
%>  
 <jsp:forward page="hello.jsp" /> 
```
在hello.jsp中通过getAttribute()方法获得用户名字：
```html
<% String username=(String)request.getAttribute("username"); %>  
 Hello: <%=username %> 
```

4、request.getAttribute 返回的是Object，request.getParameter 返回的是String。

## 接口HttpServletResponse
- 继承了ServletResponse接口
- 帮助Servlet给客户端发送响应，由服务器创建后，作为参数传递给service方法
- 通过该对象设置响应行，响应头，响应实体
`rsp.setHeader("Content-Type", "text/html; charset=UTF-8")`

### 响应行
协议版本号，状态码，描述信息，一般不需要程序员关注

### 响应头
- setHead 设置响应头，同名会覆盖
- addHead 增加响应头，同名不会覆盖

### 响应实体
- rsp.getWriter.print()

## 接口ServletConfig
- 用于在Servlet初始化的时候向Servlet提供参数
- 参数要定义在web.xml的servlet标签下
- 获取参数: config.getInitParameter
- 获取servlet的名字: config.getServletName

## 接口ServletContext
- 一个应用只有一个ServletContext对象用于表示整个应用，被所有servlet共享，也被称之为application

三种获取ServletContext的方法
- GenericServlet.getServletContext()
- getServletConfig().getServletContext()
- req.getSession().getServletContext()

### 功能
- *获取全局配置信息
- 获取路径 getContextPath，getRealPath 
- 获取WebRoot下的资源：getResourceAsStream
- 可以进行请求转发(不常用)

## 接口HttpSession
- Session会话，存储在服务器端，用于在多个页面之间标识客户端，可以存储客户端信息

### HttpSession生命周期
- 创建
    + 第一次请求的时候就创建
- 销毁
    + 客户端丢失JSESSIONID, 关浏览器
    + 服务器关闭
    + 超过最大不活动时间
        1 默认是30分钟，在Tomcat/conf/web.xml中有设置
        2 可以在本项目/web.xml中自定义时间(分钟)
        3 可以通过Servlet中API设置session.setMaxInactiveInterval(seconds)
    + 手动session.invalidate()

### Session超时设置说明
 1.优先级：Servlet中API设置 > 程序/web.xml设置 > Tomcat/conf/web.xml设置
 2.若访问服务器session超时（本次访问与上次访问时间间隔大于session最大的不活动的间隔时间）了，即上次会话结束，但服务器与客户端会产生一个新的会话，之前的session里的属性值全部丢失，产生新的sesssionId
 3.客户端与服务器一次有效会话（session没有超时），每次访问sessionId相同，若代码中设置了session.setMaxInactiveInterval()值，那么这个session的最大不活动间隔时间将被修改，并被应用为新值。
 4.Session的销毁（代表会话周期的结束）：在某个请求周期内调用了Session.invalidate()方法，此请求周期结束后，session被销毁；或者是session超时后自动销毁；或者客户端关掉浏览器
 5.对于JSP，如果指定了<%@ page session="false"%>，则在JSP中无法直接访问内置的session变量，同时也不会主动创建session，因为此时JSP未自动执行request.getSession()操作获取session。


### HttpSession的跟踪机制
通过Cookie来管理，在Cookie中通过JSessionID来表示客户端

### HttpSession运行原理.
1. 当客户端浏览器访问服务器时,服务器接收请求后会判断请求中是否在Cookie包含JSESSIONID.
2. 如果包含JSESSIONID把对应值取出,做为Key从全局Map<String,Session>(把Redis当成这个大Map)对象往出取Session对象.
3. 如果有对应的key,把Session对象取出.根据自己业务添加操作.
4. 如果请求对象中JSESSIONID在全局Map<String,Session>没有或请求对象中Cookie没有JSESSSIONID ,会执行新建Session步骤
5. Tomcat会新建(new)一个Sesssion对象,同时产生一个UUID,把UUID做为Map的key,新建的Session对象做为Value,还会把UUID放入到Cookie做为value,value对应的Key是JSESSIONID



## 类Cookie

`public class Cookie extends Object implements Cloneable`

- Cookie: 它用于存储一些少量的信息，首先在Servlet中`Cookie myCookie = new Cookie();`创建，然后可以通过`rsp.addCookie(myCookie)`发送到客户端浏览器进行保存，在之后的访问服务器的过程中，浏览器会自动携带Cookie信息
- Cookie信息默认存储于浏览器内存中, 关闭浏览器或使用不同的浏览器, 均无法获取到cookie信息
- 可以通过setMaxAge(seconds)方法给Cookie设置最大存活时间。设置后，Cookie会保存到本地硬盘中，到期后自动删除。
- setMaxAge(0)会将cookie删除
- 可以通过setPath(uri)方法给Cookie设置访问路径信息，设置后，只有访问固定模式路径时，浏览器发出请求才会携带cookie信息
- 后台可以通过getCookies()方法获取cookie信息，比较方便

## 保存状态的两种方式
Cookie存储于客户端，不适合保存大量的数据，不安全，效率低
Session存储于服务器端，适合保存大量的数据，安全，效率高；
Session跟踪机制中需要cookie来保存和传递sessionId

## 解决中文乱码问题

### 前台页面乱码
<meta http-equiv="content-type" content="text/html; UTF-8" />

### 后台代码乱码

#### 请求乱码
- POST请求
    + req.setCharacterEncoding("UTF-8");//针对请求实体
- GET求
    + 写代码，`String uname = req.getParameter("uname"); byte[] b1 = uname.getBytes("iso-8859-1"); uname = new String(b1, "utf-8");`
    + 或者，在tomcat的server.xml配置Connector元素的URIEncoding属性="utf-8"
    //针对请求参数
    + 或者，在tomcat的server.xml配置Connector元素的UseBodyEncodingforURI属性="true"

#### 响应乱码
- rsp.setCharacterEncoding("UTF-8");//针对响应实体
- rsp.setHeader("Content-Type", "text/html; charset=utf-8");
- rsp.setContentType("text/html; charset=utf-8");
    + 注意：一定要写在`rsp.getWriter()方法之前`，否则生成的PrintWriter对象的编码默认已经是`ISO-8859-1`，导致HTML页面出现乱码

## 页面跳转的两种方式
- 请求转发
    + req.getRequestDispatcher(path).forward(req, rsp);
    + 只会发送一次请求
    + 在转发后，数据可以继续传递
    + 地址栏保持初次请求的路径，不会发生改变
    + 转发代码后面的代码还可以执行，但是不能再次进行转发
    + 请求转发只能跳转到内部资源，不能访问外部资源

- 重定向[Status Code:302]
    + 重定向，发送两次请求
    + 重定向时，地址栏会发生改变
    + 重定向时，需要手动添加请求参数数据
    + 重定向后的代码可以继续执行，但是一次重定向后不能再次重定向
    + 重定向既可以访问内部资源，也可以访问外部资源

## Tomcat

### Tomcat8默认编码
[Tomcat 8 changelog](http://tomcat.apache.org/tomcat-8.0-doc/changelog.html#Tomcat_8.0.44_(violetagg)) 
`Change the default URIEncoding for all connectors from ISO-8859-1 to UTF-8. (markt)`

### 响应实体设置字符集
在tomcat8中实际测试发现，rsp.setCharacterEncoding("UTF-8");没有起作用
可以使用rsp.setHeader("Content-Type", "text/html; charset=UTF-8");



### 版本问题
ServletRequest的getServletContext方法是Servlet3.0添加的，这个可以看一下官方文档
http://docs.oracle.com/javaee/6/api/javax/servlet/ServletRequest.html#getServletContext()
而Tomcat6只支持到Servlet2.5看它的官方文档可以知道，要用J2EE6的话得换成Tomcat7
http://tomcat.apache.org/tomcat-6.0-doc/index.html
旧版本需要先用request拿到HttpSession或者通过Servlet自身拿到ServletConfig之后再获取ServletContext

## Servlet三大作用域
三个方法 set/get/remove+Attribute
HttpServletRequest
HttpSession
ServletContext
作用域的生命周期和作用范围

### request作用域-->HttpServletRequest：
- 生命周期
    + 一次请求的时候开始
    + 本次请求完成就结束
- 作用范围
    + 所有请求转发向后涉及的Servlet中可用

### session作用域-->HttpSession：
- 生命周期
    + 第一次请求的时候开始
    + 关闭浏览器/关闭服务器/超过最大不活动时间
- 作用范围
    + 本次会话中所有的Servlet都可用

### application作用域-->ServletContext：
- 生命周期
    + 开始 项目被部署
    + 结束 服务器关闭，或者项目被移除
- 作用范围
    + 本项目的所有Servlet都可用

## 路径

### 根路径
- 服务器根路径
  http://localhost:8080/
- 项目根路径
  http://localhost:8080/bjsxt/

### 相对路径和绝对路径
#### HTML前端
+ 相对定位
+ 绝对定位
/ 服务器跟路径
/bjsxt 项目根路径

`<head><base href="http://192.168.2.40:8085/myapp/"></head>`
人为地固定当前路径为：项目根路径
`<a href="#">当前路径</a>`

#### Java后台
```java
//aa.jsp
        //TODO 请求转发
        //相对路径  由于web.xml中 <url-pattern>/a/testPath.action</url-pattern>
        //         这里当前路径就是/a/
//        req.getRequestDispatcher("aa/aa.jsp").forward(req, rsp);
        //绝对路径  /表示项目根路径
//        req.getRequestDispatcher("/a/aa/aa.jsp").forward(req, rsp);

        //TODO 重定向
        //相对路径  由于web.xml中 <url-pattern>/a/testPath.action</url-pattern>
        //         这里当前路径就是/a/
//        rsp.sendRedirect("aa/aa.jsp");
        //绝对路径  /表示服务器根路径
        rsp.sendRedirect(req.getContextPath() + "/a/aa/aa.jsp");

        return;
```

- 请求转发
    + 相对定位
    + 绝对定位
    / 项目根路径

- 重定向
    + 相对定位
    + 绝对定位
    / 服务器根路径

## JSP
Jsp也是Servlet

### JSP的执行过程
xxx.jspweb.xmlJspServletxxx_jsp.javaxxx_jsp.class_jspService()浏览器显示

### JSP中声明变量
`<% int a= 5; %>` 局部变量
`<%! int a = 10; %>` 成员变量   

### JSP中注释
最彻底地注释JSP注释 <%-- --%>
`<%--this is a JSP comment.it will only be seen in jsp code--%>`

### MVC(JavaBean, jsp, Servlet)

### JSP编译器指令
<% @page %>
- import属性
- pageEncoding属性
- errorPage属性
<% @include %>
- 用于在页面中包含其他页面，静态引入，会生成一个java文件，变量名重复时会出错
- 动态引入要使用jsp动作标签: <jsp:include></jsp:include>，会生成两个java文件，所以不会有变量重名的情况
<% @taglib %>

### JSP脚本语法
- HTML注释”:<!-- comments -->
Servlet中会生成，会发给浏览器
- “隐藏注释”:<%-- comments --%>
Servlet中不生成，不发给浏览器
- “声明” <%! 声明; [声明; ] ... %>
- “表达式” <%=…%>
- “脚本段” <%...%>


### JSP九大内置对象
- 四个作用域
    + pageContext (页面上下文对象)当前页面有效
    + request 一次请求/所有请求转发涉及到的Servlet
    + session 一次会话/所有的servlet
    + application 从整个应用加载，到应用被卸载，所有Servlet
- 两个输出
    + response response.getWriter().print()
    + out 程序员一般不用
- 三个打酱油
    + page 
    + config 对应ServletConfig对象，
    + exception

## EL表达式
- 使用方式${}
- 用于获取提交的数据：${param.dataName} ${paramValues.dataName}
- 用户获取作用域中的数据: ${dataName}
- 运算符：empty, eq, ne...

不建议在页面中进行复杂的判断，否则就违背了初衷

## JSTL标签库
先要使用<%@ taglib uri="" prefix="" %>标签引入标签库才能使用

### 核心标签库
- uri="" prefix="c"
- set out remove if (choose when otherwise) foreach

### <c:if>标签
```jsp
<c:if test="<boolean>" var="<string>" scope="<string>">
    ...
</c:if>
```
test|条件|必要
var|用于存储条件结果的变量|
scope|var属性的作用域|

标签判断表达式test的值，如果表达式的值为true则执行其主体内容

#### 注意事项
uri属性需要.tld文件支持

### 格式化标签库
- fromatDate formatNum parseDate parseNum

### 函数标签库
- ${fn:length(str)} trim contains join

### 自定义函数标签库
- 在WEB-INF下new一个tld文件，将fn.tld下的内容复制并修改为需要的内容
- 创建一个java类，定义公开的静态的方法，供tld文件配置使用
- 配置好tld文件，使用方式和默认的jstl函数标签库一致

### 自定义标签
- 在WEB-INF下创建一个tld文件
- 将c.tld下的内容复制到myTab.tld中，进行适当修改
- 创建一个Java类，继承TagSupport类，重写doStartTag()和doEndTag()
- 在类中声明成员属性，提供getter和setter方法，用来被标签自动调用
- 使用方法和普通jstl一样

## 接口Filter

- 方法：
    + init
    + doFilter
    + destroy
- 作用
    + 在访问对象资源前，先执行过滤器，然后再继续访问
    + 一定要在web.xml中配置好过滤器才能使用
    + 过滤器的执行顺序和`<filter-mapping>`的顺序相关
    + 放行时候，使用`filterChain.doFilter(req, rsp);`

### Login登录过滤器白名单
一定会有请求白名单(登录验证请求，验证码请求)

## 监听器
- 有8个接口
- 功能是用于监听作用域的变化
- request有两个，application有两个，session有四个
- 记录请求信息，设置basePath，监听在线人数(session)
- 一般情况下，filter要配置在servlet之前，listener之后

## 配置web.xml
order:
- 先配listener
- 再配filter
- 最后配servlet

## AJAX

### XHR创建对象
XMLHttpRequest 是 AJAX 的基础。

### XHR请求

#### XMLHttpRequest.open()
初始化 HTTP 请求参数
语法
open(method, url, async, username, password)
method 参数是用于请求的 HTTP 方法。值包括 GET、POST 和 HEAD。
url 参数是请求的主体。大多数浏览器实施了一个同源安全策略，并且要求这个 URL 与包含脚本的文本具有相同的主机名和端口。
async 参数指示请求使用应该异步地执行。如果这个参数是 false，请求是同步的，后续对 send() 的调用将阻塞，直到响应完全接收。如果这个参数是 true 或省略，请求是异步的，且通常需要一个 onreadystatechange 事件句柄。
username 和 password 参数是可选的，为 url 所需的授权提供认证资格。如果指定了，它们会覆盖 url 自己指定的任何资格

### XHR响应

### XHRreadyState

## What is 连接池技术:
连接池解决方案是在应用程序启动时就预先建立多个数据库连接对象,然后将连接对象保存到连接池中。
当客户请求到来时,从池中取出一个连接对象为客户服务。
当请求完成时,客户程序调用close()方法,将连接对象放回池中. 
对于多于连接池中连接数的请求，排队等待。
还可根据连接池中连接的使用率，动态增加或减少池中的连接数。

## 第三方连接池proxool初始化
Proxool 配置初始化
- Proxool.properties 或者
- Proxool.xml 两种方式初始化


## 使用连接池Proxool步骤
- 加载jar包
- 编写配置文件
- 编写连接池工厂类(单例模式)
- 获取链接

### 测试连接池

## Web环境下使用连接池Proxool
- web.xml配置ServletConfiguration并设置自动加载

```xml
    <!--Web配置连接池proxool，自动加载(load-on-startup=1)-->
    <servlet>
        <servlet-name>ServletConfigurator</servlet-name>
        <servlet-class>org.logicalcobwebs.proxool.configuration.ServletConfigurator</servlet-class>
        <init-param>
            <param-name>propertyFile</param-name>
            <param-value>WEB-INF/classes/proxool.properties</param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>
```
- DBUtil中获取连接
- 监控proxool连接池，可以在web.xml配置AdminServlet

## 过滤器配置多个url-pattern
```xml
    <!--配置 过滤器 mapping-->
    <filter-mapping>
        <filter-name>LoginFilter</filter-name>
        <url-pattern>*.action</url-pattern>
        <url-pattern>*.jsp</url-pattern>
        <url-pattern>*.html</url-pattern>
    </filter-mapping>
```
只过滤action,jsp,html三种资源请求

## 获取并持久化项目基础路径BasePath
```java
public class BasePathListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {

        //生成一个BasePath
        //http://2.40:8085/stu/
        String basePath = sce.getServletContext().getContextPath() + "/";//--/stu
        System.out.println("BasePathListener.contextInitialized  生成一个basePath--->"+basePath);
        sce.getServletContext().setAttribute("basePath", basePath);
    }
}
```
通过ServletContextEvent对象获取ServletContext, 调用getContextPath()，获取项目根路径，+"/"-->BasePath
并set进application作用域中
后续再通过${applicationScope.basePath}获取到，并通过`<base href="${applicationScope.basePath}">`设置给当前页面，
该页面所有其他相对路径都参照该basePath，进行请求资源


## 表单验证记录
```js
function checkAll() {
    var flag = true;
    var t = $("#codeSpan").html();
    if(t == "" || t.indexOf("no")>0) {
        checkCode();
        return false;
    }
    return flag && checkUname() && checkUpwd();
}
```

## My97DatePicker日期控件
- My97DatePicker目录，不可破坏里面的目录结构，也不可对里面的文件改名，可以改目录名
- My97DataPicker.htm是必须文件，不可删除
- 各目录及文件的用途
    + WdatePicker.js配置文件，在调用的地方仅需使用该文件，可多个共享
    + config.js语言和皮肤配置，无需引入
    + calendar.js日期库主文件，无需引入
    + My97DatePicker.htm临时页面文件，不可删除

# SOA
Service Oriented Architecture

# WebService


## iframe
iframe一般用来包含别的页面，例如我们可以在我们自己的网站页面加载别人网站或者本站其他页面的内容

   一、页面内加入iframe

    <iframe width=420 height=330 frameborder=0 scrolling=auto src=URL></iframe>，

    scrolling表示是否显示页面滚动条，可选的参数为auto、yes、no，如果省略这个参数，则默认为auto。

    二、超链接指向这个嵌入的网页，只要给这个iframe命名就可以了。方法是<iframe name=**>，例如我命名为aa，写入这句HTML语言<iframe width=420 height=330 name=aa frameborder=0 src=http://host.zzidc.com></iframe>，然后，网页上的超链   接语句应该写为：<a  href=URL target=aa>

    三、如果把frameborder设为1，效果就像文本框一样

    透明的iframe的用法

    必需IE5.5以上版本才支持

    在transparentBody.htm文件的<body>标签中，我已经加入了style="background-color=transparent" 通过以下四种iframe的写法我想大概你对iframe背景透明效果的实现方法应该会有个清晰的了解：

    <iframe ID="Frame1" SRC="transparentBody.htm" allowTransparency="true"></iframe>

    <iframe ID="Frame2" SRC="transparentBody.htm" allowTransparency="true" STYLE="background-color: green"> </iframe>

    <iframe ID="Frame3" SRC="transparentBody.htm"></iframe>

    <iframe ID="Frame4" SRC="transparentBody.htm" STYLE="background-color: green"> </iframe>


### javascript五种数据类型
Undefined
Null 值只有一个 null
Boolean
String
Number

