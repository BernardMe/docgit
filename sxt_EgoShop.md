

# Ego商城笔记


## Server部署情况

### dubbo_admin部署@centos_01

### 注册中心zookeeper/redis集群部署@zookeeper

### Solr集群部署@centos_02

## 创建六个项目

ego_parent 父项目
ego_commons 存放工具类等
ego_pojo 实体类
ego_item 商品系统
ego_portal 门户系统
ego_search 搜索系统
ego_passport 单点登录系统
ego_cart 购物车系统
ego_manage 后台系统
ego_service RPC服务接口
ego_service_imp RPC实现系统
ego_redis 缓存系统






## ego_commons 存放工具类等
放Mapper


## ego_service_imp dubbo实现类

### imp包


### Test类启动

### Log4J设置打印SQL
log4j.properties中
`log4j.logger.com.ego.mapper=DEBUG`


## ego_manage 消费者后台
`消费者后台只能依赖Dubbo的服务接口`
如果直接依赖实现类，那就没用到Dubbo


2. 把后台页面放在ego-manage/WEB-INF中
 
3. 在ego-manage编写控制器类
@Controller
public class PageController {
	@RequestMapping("/")
	public String welcome(){
		return "index";
	}
	@RequestMapping("{page}")
	public String showPage(@PathVariable String page){
		return page;
	}
}



### 显示商品类目tree



## 内容分类管理

## Solr  

Solr就是一个搜索引擎系统


### SolrJ

export CATALINA_HOME=/usr/local/solr/tomcat
export CATALINA_BASE=/usr/local/solr/tomcat



<delete>
	<query>*:*</query>
</delete>
<commit/>



## SSO单点登录



### Cookie 复习
1. 解释:客户端存值技术.
1.1 存储位置:客户端浏览器.
1.2 作用:存值
1.3 存值类型: 只能存储字符串.
2. Cookie运行原理:
2.1 当浏览器输入URL访问服务器时会自动携带所有有效Cookie(时间内,指定路径内,指定域名内),Tomcat接收请求后会把Cookie放入到HttpServletRequest中,在代码中通过request对象获取到Cookie的内容.
2.2 服务器内容可以产生Cookie内容,需要放入到响应对象中响应给客户端浏览器.(要求跳转类型为重定向.),客户端浏览器接收响应内容后会把Cookie内容存储到指定文件夹内容.
3. 产生cookie
```java
@RequestMapping("demo")
	public String goIndex(HttpServletResponse response){
		Cookie c = new Cookie("key", "value");
		//1. 默认实现和HttpSession相同.
		//设置cookie存活时间,单位秒
//		c.setMaxAge(10);
		//2. 默认存储路径为path=/
		
		//设置哪个目录下资源能访问
		c.setPath("/");
		//3. 域名和当前项目的域名相同
		c.setDomain(".bjsxt.com");
		response.addCookie(c);
		return "redirect:/index.jsp";
	}
```
4. 获取cookie
```java
<% 
	Cookie [] cs = request.getCookies();
	if(cs!=null){
		for(Cookie c :cs){
			out.print("key:"+c.getName()+",value:"+c.getValue()+"<br/>");
		}
	}else{
		out.println("没有cookie");
	}
%>
```


### HttpSession运行原理.
1. 当客户端浏览器访问服务器时,服务器接收请求后会判断请求中是否在Cookie包含JSESSIONID.
2. 如果包含JSESSIONID把对应值取出,做为Key从全局Map<String,Session>对象往出取Session对象.
3. 如果有对应的key,把Session对象取出.根据自己业务添加操作.
4. 如果请求对象中JSESSIONID在全局Map<String,Session>没有或请求对象中Cookie没有JSESSSIONID ,会执行新建Session步骤
5. Tomcat会新建(new)一个Sesssion对象,同时产生一个UUID,把UUID做为Map的key,新建的Session对象做为Value,还会把UUID放入到Cookie做为value,value对应的Key是JSESSIONID


### 使用Redis+Cookie模拟Session步骤:
1. 流程图 
2. 步骤:
2.1 步骤1:第一次请求时Cookie中没有token
2.2 产生一个UUID,把”token”做为Cookie的key,UUID做为Cookie的value
2.3 如果希望类似往Session存储内容,直接把UUID当作redis的key(个别需要还需要考虑key重复问题.),把需要存储的内容做为value.
2.4 把cookie对象响应给客户端浏览器.




