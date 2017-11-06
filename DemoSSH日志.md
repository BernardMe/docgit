
## 项目整体框架SSH


### 数据库服务器

数据库实例服务名 10.243.5.101:1521/xe
用户名 home
密码 xb101406


修改java源代码 jsp文件 编码为UTF-8
新增com.xbw.commons 公共包

新增 请求验证结果对象 
增加 Struts2json插件支持

添加完成  uname唯一性验证   隐藏 用户注册返回密码









## DemoSSH项目试讲会(1101)

### 开发环境
JDK 1.7
Tomcat 8.0.


#t## 整体框架SSH

Struts2+Spring4+Hibernate4+Oracle+HTML5+CSS3+jQuery1.7

目前没有使用maven

前后台交互通过JSON字符串实现

### 数据库访问层

使用HibernateTemplate可将Hibernate 的持久层访问模板化，使用时传入sessionFactory实例



创建了一个获取SessionFactory的工厂类HibernateSessionFactory

UserDaoImp继承于HibernateDaoSupport(包含属性hibernateTemplate)实现了对更新数据库数据操作的Transction事务回滚操作(更新操作抛出异常时回滚事务)
UserDaoImp使用`HQL实现查询操作`
UserDaoImp使用`传入VO实现更新操作`


数据库连接池实现使用C3P0类库
```xml
<!-- 最大连接数 -->
<property name="hibernate.c3p0.max_size">200</property>
<!-- 最小连接数 -->
<property name="hibernate.c3p0.min_size">10</property>
<!-- 获得连接的超时时间,如果超过这个时间,会抛出异常，单位秒 -->
<property name="hibernate.c3p0.timeout">180</property>
<!-- 最大的PreparedStatement的数量 -->
<property name="hibernate.c3p0.max_statements">100</property>
<!-- 当连接池里面的连接用完的时候，C3P0一下获取的新的连接数 -->
<property name="hibernate.c3p0.acquire_increment">2</property>
```


### web容器配置

`配置struts2核心过滤器作为整个前台请求的入口，没有这个核心过滤器，所有struts内容不生效`
```xml
<!-- 整个struts2的入口，配置核心过滤器，没有这个核心过滤器，所有struts内容不生效 -->
<filter>
	<filter-name>struts2</filter-name>
	<filter-class>org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter</filter-class>
</filter>
<filter-mapping>
	<filter-name>struts2</filter-name>
	<url-pattern>/*</url-pattern>
</filter-mapping>
```

`监听web容器启动后，启动Spring容器`
```xml
<listener>
	<listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
</listener>
```


### 已完成功能

注册用户
POST请求
DemoSSH/userRegist.action

参数
参数	值	长度
user.uname	xiaoming	30位数字或字母
user.upwd	123	30位数字或字母
repsw	123	30位数字或字母
user.ugender	1	1或0

返回码
成功	200
异常	500
用户名称重复	102


登录验证
POST请求
DemoSSH/userLogin.action

参数
参数	值	长度
user.uname	test	30位数字或字母
user.upwd	test	30位数字或字母
validateCode	s	1位数字或字母

返回码
验证成功	200
用户名或密码错误	500
验证码输入错误, 表单输入有误	101







