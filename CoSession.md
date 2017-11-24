[TOC]



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




# 分布式系统中Session到底能不能共享
>
答案一定是能。





# 重写servlet API实现分布式session共享

在使用分布式 session 前会有这样两个疑问：

## 1）为什么采用分布式 session ：
当我们的系统当中有多台服务器的时候，我们无法保证 session 在多台机器都存在，这是因为我们用户的请求不一定会被路由到同一台机器上。也就是说对应一个用户的 session 信息在服务器 A 上存在，但是在服务器 B 上不存在，因为请求被路由到了服务器 A 上，所以我们需要让集群中的多台机器共享 session信息。


## 2）为什么重写 session：
session 只能存储在本地 web服务器的内存当中，但无法满足 session 在多台服务器的分布式环境下，多台机器共享 session 数据的问题，所以我们需要重写，让它在分布式环境下，拥有 session 数据共享功能。
![基于Redis存储的session方案](./基于Redis存储的session方案.jpg)

session配置方法
当程序需要为某个客户端的请求创建一个 session 的时候，服务器首先检查这个客户端的请求里是否包含了一个 session 标识，称为 session-id。
如果已经包含一个 session-id 则说明以前已经为此客户创建过 session，服务器就按照session-id 把这个 session 检索出来使用(如果检索不到，可能会新建一个，这种情况可能出现在服务端已经删除了该用户对应的 session 对象，但用户人为地在请求的 URL 后面附加上一个 JSESSION 的参数)。
如果客户请求不包含 session-id，则为此客户创建一个 session 并且生成一个与此 session 相关联的 session-id，这个session-id将在本次响应中返回给客户端保存。
其实分布式 session 并不是一个特别难的课题，实现的思路也有很多种。今天我将介绍一种使用起来非常简单的方法，只要做如下配置即可使用：
1 ）导入一个 jar 在 pom 文件中
![com.pcx的maven依赖](./com.pcx的maven依赖.jpg)

2） 在 web.xml 文件中配置一个 filter
![在web.xml中配置一个filter](./在web.xml中配置一个filter.jpg)

session 使用方法
分布式 session 的使用：从使用者的角度不需要知道是否为分布式 session，一句即可搞定，而且和容器无关。
为了保证读者可以理解这种方法，下面我将以最简洁的方法来实现。

## 1、 拦截器的实现
这个拦截器拦截了所有路径的客户端请求，并且在请求进去 Controller 之前把HttpServletRequest 替换成我自己实现的一个 HttpServletRequest，叫做DistributionSessionRequestWrapper
![DistributionSessionRequestFilter](./DistributionSessionRequestFilter.jpg)

## 2、 DistributionSessionRequestWrapper 的实现
![DistributionSessionRequestWrapper](./DistributionSessionRequestWrapper.jpg)


HttpServletRequestWrapper 是 HttpServletRequest 的装饰类,通过继承它，覆盖你希望改变的方法，你可以改变当前 HttpServletRequest 对象的状态。
从 session 的使用角度上来说，你只会用 getSession() 这个方法，那么我覆盖这个方法就ok了，在 getSession() 中我做了两件事：
new 了一个的 HttpSession 实现叫做 DistributionSessionImpl
在 cookie 当中写入一个叫 pcxSessionId 的 cookie 进去，实际上就和 tomcat 的 jessionid 一样，这个就是用来从分布式缓存中寻找对应 session 数据的 key。

## 3、 DistributionSessionImpl的实现
![DistributionSessionImpl的实现](./DistributionSessionImpl的实现.jpg)

在 DistributionSessionImpl 中有两个属性比较重要
sessionMap用来存储一次请求中的 session 数据
sessionStore把用户的 session 数据存储到分布式缓存的类
getId() 方法通过这个方法可以获取用户的 cookie 中 key=pcxSessionId的value 值

getAttribute()通过key中 pcxSessionId从缓存中获取用户的 session 数据

setAttribute()如果为空的话，那么从分布式缓存中获取用户的 session 数据，当然如果这个用户是第一次访问的话，这个 sessionMap 可能还是为空，这个逻辑的话在sessionStore 有判断；把key-value数据存储到本地的sessionMap中，然后把数据推送到分布式缓存中
removeAttribute()清除本地 map 中的 Attribute 然后再把分布式缓存中的getID() 给删掉
Invalidate()先清除本地的 sessionmap 然后删除分布式缓存中的 session 数据，最后清除cookie

## 4、 SessionStore的实现

![SessionStore的实现](./SessionStore的实现.jpg)

session 存储的时候使用 hession 的序列化，然后通过调用 jedis的 api 存放session 数据。这个类应该是很容易理解的，当然具体你用 redis 还是 memcached 这个随意了。

至此，一个基本的分布式 session 就实现了。

它的本质`是加一个拦截器然后把 HttpServletRequest 替换成自己定义了，然后覆盖掉 getSession 方法，最后用一个我自己定义的 HttpSession 实现来完成各种操作。`

## 总结
上述代码只是保留了最基本的实现，我们也可以继续优化封装，添加更多的功能。下面笔者以减少用户与分布式缓存机器的通信次数的优化为例，供大家参考。
从 DistributionSessionImpl 中我们可以看出，每次 setAttribute 和removeAttribute 数据都会同步到分布式缓存，这个实际上是没有必要的，虽说分布式缓存和我们的 server 虽然是在内网中通信，但是来回的次数会增加其时间损耗。
我们不能保证把一个用户的请求一直路由到同一台机器上，但是能够保证一次 request 在一台机器上，我们可以在用户的一次请求结束后把这个用户的 Session 数据同步到分布式缓存当中，以减少了与分布式缓存机器的通信次数。


