

## SpringMVC

### SpringMVC中重要组件
DispatcherServlet：前端控制器，接收所有请求(如果配置`/`不包含jsp)
HandlerMapping：解析请求格式的，判断希望要执行的哪个类的方法
HandlerAdaptor：负责调用具体的方法
ViewResolver：视图解析器，解析结果，准备跳转到具体的物理视图

### SpringMVC原理

大前提
如果在web.xml中设置Dispathcer的urlpattern为  `/`  时

当用户发起请求，请求一个控制器时，
首先会执行 DispatcherServlet 查询 HandlerMapping解析URL寻找处理器
DispatcherServlet通过HandlerAdaptor将请求提交到 controller中的处理业务方法，
当处理业务方法执行完成后会返回处理结果，
DispatcherServlet查询ViewResovler进行视图解析，
找到处理结果对应的视图
视图负责把运行.class文件的结果响应给客户端，

===以上就是springmvc运行原理(给面试官)


### Spring容器和SpringMVC容器的关系
Spring容器和SpringMVC容器是父子容器

SpringMVC容器能够调用Spring容器的所有资源
![SpringMVC_container.png](./SpringMVC_container.png)



### 传参
- 把内容写到方法(HandlerMethod)参数中，SpringMVC只要有这个内容，注入内容

- 基本数据类型参数
  + 默认保证参数名称和请求中传递的参数名相同
  + 如果请求参数名和方法参数名不对应使用@RequestParam()赋值
  + 如果方法参数是基本数据类型(不是封装类)可以通过@RequestParam设置默认值.
    - 防止没有参数时500
  + 如果强制要求必须有某个参数`@RequestParam(required=true) String name`
- 方法(HandlerMethod)中参数是对象类型

- 请求参数中包含多个同名参数的获取方式
  + `复选框传递的参数就是多个同名参数`

```java
@RequestMapping("demo5")
  public String demo5(String name,int age,@RequestParam("hover")List<String> abc){
    System.out.println(name+"  "+age+"  "+abc);
    return "main.jsp";
  }
//页面
 //<input type="checkbox" name="hover" value="1">1
//输出：
//www  25  [on, on]
//www  25  [2, 3]
```
- 请求参数中对象.属性格式
  + jsp中代码
```
  <input type="text" name="peo.name"/>
  <input type="text" name="peo.age"/>
```
  + 新建一个类
    - 对象名和参数中点前面名称对应

```java
public class Demo {
  private People peo;//还得有一个people类里面有两个属性name和age
}
```
  + 控制器
```java
  @RequestMapping("demo6")
  public String demo6(Demo demo){
    System.out.println(demo);
    return "main.jsp";
  }
```
- restful传值方式
  + 简化jsp中参数编写格式
  + 在jsp中设定特定的格式
  <a href="demo8/123/abc">跳转</a>
  + 在控制器中
    - 在@RequestMapping中一定要和请求格式对应
    - {名称} 大括号是占位符，大括号内的中名称自定义名称，可以随便取
    - @PathVariable 获取@RequestMapping中的内容,默认按照方法参数名称去寻找.

```java
  @RequestMapping("demo8/{id1}/{name}")
  public String demo8(@PathVariable String name,@PathVariable("id1") int age){
    System.out.println(name +"   "+age);
    return "/main.jsp";《绝对路径》
  }
```



### 视图解析器

#### 默认配置
在src下新建springmvc.xml没有配视图解析器使用的是默认的视图解析器

### 自定义视图解析器

不能加前缀 

#### forword:或redirect:
如果希望不执行自定义视图解析器，就在方法返回值前面添加forword：或redirect：，这样就不走配置的视图解析器，而走默认的视图解析器

```java
 @RequestMapping("demo10")
    public String demo10() {
        return "redirect:demo11";
    }
```
上面demo10的返回值前加了forword 就认为执行完demo10 后执行demo11这个方法，相当于一个servlet跳到另一个servlet


### @ResponseBody
1. 在方法上只有@RequestMapping时,无论方法返回值是什么认为需要跳转,`只有返回值类型是void才不跳转》`

2. 在方法上添加@ResponseBody(恒不跳转)
- 如果返回值满足key-value形式(对象或map)
  + 把响应头设置为application/json;charset=utf-8
  + 把返回值转换成json形式
  + 把转换后的内容输出流的形式响应给客户端.
- 如果返回值不满足key-value,例如返回值为String
  + 把相应头设置为text/html
  + 把方法返回值以流的形式直接输出《方法返回值是什么就输出什么》.
  + 如果返回值包含中文,出现中文乱码
    - 2.2.3.1 produces表示响应头中Content-Type取值.

```java
@RequestMapping(value="demo12",produces="text/html;charset=utf-8")
@ResponseBody
public String demo12() throws IOException{
People p = new People();
p.setAge(12);
p.setName("张三");
return "中文";
}
```

3. 底层使用Jackson进行json转换,在项目中一定要导入jackson的jar
- spring4.1.6 对jackson不支持较高版本,jackson 2.7 无效.






### 四大作用域

#### page

#### request
一次请求结束后，下一次请求重新实例化一个request对象

#### session
- 一次会话
- 只要 传递的 jsessionid不变，都是同一个session会话
- 实际有效时间
-

#### application
- 出于安全考虑，application不允许作为参数传递


### SpringMVC传值方式

#### 四大作用域原生传值方式
在handlerMethod参数中添加作用域对象

```java
public String demo1(HttpServletRequest abc,HttpSession sessionParam){
    //request作用域
    abc.setAttribute("req", "req的值");
    //session作用域
    HttpSession session = abc.getSession();
    session.setAttribute("session", "session的值");
    sessionParam.setAttribute("sessionParam", "sessionParam的值");
}
```

#### map传值
相当于把map中内容放入request作用域

#### Model传值
相当于把内容最终放入到request作用域中
model.addAttribute("model", "model的值");

#### modelAndView传值
使用SpringMVC中的ModelAndView类
mav.addObject("mav", "mav的值");


## 文件下载

访问资源时，响应头如果没有设置Content-Disposition,浏览器默认按照inline值进行处理，能显示就显示，不能就下载

设置响应流响应头信息，文件的处理方式
Content-Disposition，"attachment;fileName=bbb.txt"
获取文件路径 用完整磁盘路径、

attachment;fileName=bbb.txt


## 文件上传

encType="Multipart/form-data"  

在java中，Multipart对象名要和 <input type="upload" >name属性一致

在springmvc.xml中配置MultipartResolver 解析器

```xml
<!-- 配置MultipartResolver 解析器 -->
<bean id="MultipartResolver" class=""  >
  <property name="maxUploadSize" value="50"></property>
</bean>
```


## Spring 拦截器

定义拦截器之后就不能直接访问控制器controller中的方法了，必须先经过拦截器才能进入控制器中的方法

### AOP与Filter对比

Filter拦截的是请求

AOP拦截的是特定方法前后扩充(对ServiceImpl)

Spring拦截器 只能拦截控制器controller(对controller)



- 全拦截 
- 或 只拦截特定 controller
<mvc:interceptors>  
    <!-- 使用bean定义一个Interceptor，直接定义在mvc:interceptors根下面的Interceptor将拦截所有的请求 -->  
    <bean class="com.host.app.web.interceptor.AllInterceptor"/>  
    <mvc:interceptor>  
        <mvc:mapping path="/test/number.do"/>  
        <!-- 定义在mvc:interceptor下面的表示是对特定的请求才进行拦截的 -->  
        <bean class="com.host.app.web.interceptor.LoginInterceptor"/>  
    </mvc:interceptor>  
</mvc:interceptors>  

### 实现HandlerInterceptor接口

HandlerInterceptor 接口中定义了三个方法，我们就是通过这三个方法来对用户的请求进行拦截处理的。
#### preHandle (HttpServletRequest request, HttpServletResponse response, Object handle) 方法
该方法的返回值是布尔值Boolean 类型的，当它返回为false 时，表示请求结束，后续的Interceptor 和Controller 都不会再执行；当返回值为true 时就会继续调用下一个Interceptor 的preHandle 方法，如果已经是最后一个Interceptor 的时候就会是调用当前请求的Controller 方法
#### postHandle (HttpServletRequest request, HttpServletResponse response, Object handle, ModelAndView modelAndView) 
#### afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handle, Exception ex) 方法

### 过滤器_拦截器_service()方法_dispatc()方法的执行顺序

![过滤器_拦截器_service()方法_dispatc()方法的执行顺序](./过滤器_拦截器_service()方法_dispatc()方法的执行顺序.jpg)

```java
  /**
     * 在业务处理器处理请求之前被调用

     * 如果返回false
     *     从当前的拦截器往回执行所有拦截器的afterCompletion(),再退出拦截器链
     
     * 如果返回true
     *    执行下一个拦截器,直到所有的拦截器都执行完毕
     *    再执行被拦截的Controller
     *    然后进入拦截器链,
     *    从最后一个拦截器往回执行所有的postHandle()
     *    接着再从最后一个拦截器往回执行所有的afterCompletion()
     */
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

    ...
  }
```





### Ajax与Controller的参数交互

#### jQuery.ajax( options )中重要参数设置

jQuery.ajax( options ) : 通过 HTTP 请求加载远程数据。通过jQuery.ajax与SpringMVC的Controller交互时候，需要关注以下几个参数(一个典型的ajax请求代码如下)：
```js
$.ajax({
      type: "POST",
      url: "$!{_index}/buAuth/save4",
      data:JSON.stringify(dataObj) ,
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: function (response, ifo) {}
});
```
##### contentType
    参数类型：String
    说明：(默认: “application/x-www-form-urlencoded”) 发送信息至服务器时内容编码类型。默认值适合大多数应用场合。告诉服务器从浏览器提交过来的数据格式。
    　　例如：我们提交数据时假如使用了 JSON2.js 中方法 JSON.stringify(obj) 格式化为json字符串后，再默认提交就会报错。这个时候就需要指定提交的内容格式为：”application/json”。
    
##### data
    参数类型：Object,String
    说明：发送到服务器的数据。若data数据类型为JavaScript对象或数组，Jquery在提交之前自动调用JQuery.param()方法把要发送的数据编码成为”application/x-www-form- urlencoded”格式的数据（即 name=value&name1=value1），此时参数为Object并且必须为 Key/Value 格式；如果为数组，jQuery 将自动为不同值对应同一个名称。如 {foo:[“bar1”, “bar2”]} 转换为 ‘&foo=bar1&foo=bar2’；
    　　若data数据类型为String类型，则直接默认该数据已经按照”application/x-www-form-urlencoded”格式编码完成，不再转换。
    
##### dataType
    参数类型：String
    说明：预期服务器返回的数据类型。设定HttpHeader中“Accept”域的内容，告诉服务器浏览器可以想要返回的数据格式类型，同时JQuery也会根据该类型对返回的数据进行处理。如果不指定，jQuery 将自动根据 HTTP 包 MIME 信息返回 responseXML 或 responseText，并作为回调函数参数传递，可用值:
    “xml”: 返回 XML 文档，可用 jQuery 处理。
    “html”: 返回纯文本 HTML 信息；包含 script 元素。
    “script”: 返回纯文本 JavaScript 代码。不会自动缓存结果。
    “json”: 返回 JSON 数据 。JQuery将返回的字符串格式数据自动转化为Javascript对象，便于直接使用obj.property格式访问。若没有指定该选项，即使返回的是JSON格式的字符串，JQuery也不会自动转换。
    “jsonp”: JSONP 格式。使用 JSONP 形式调用函数时，如 “myurl?callback=?” jQuery 将自动替换 ? 为正确的函数名，以执行回调函数。



#### Controller中接受参数

##### @RequestBody注释进行参数传递

```java
@RequestMapping(value = "buAuth/save1")
@ResponseBody
public String save1(@RequestBody BuAuth buAuth){
    return "SUCCESS";
}
```
采用@RequestBody标注的参数，SpringMVC框架底层能够自动完成JSON字符串转对应的Bean并注入到方法参数中，主要是通过使用HandlerAdapter 配置的HttpMessageConverters来解析post data body，然后绑定到相应的bean上的。此时Ajax发送的data值必须为Json字符串，如果Controller中需要映射到自定义Bean对象上上，则必须设置Ajax的contentType为application/json（或application/xml）。这种方式完整举例如下：

```js
$.ajax({
    type: "POST",
    url: "$!{_index}/buAuth/save1",
    data:JSON.stringify(dataObj) ,//传递参数必须是Json字符串
    contentType: "application/json; charset=utf-8",//必须声明contentType为application/json,否则后台使用@RequestBody标注的话无法解析参数
    dataType: "json",
    success: function (response, info) {}
});
```

```java
@RequestMapping(value="buAuth/save1")
@ResponseBody
public String save1(@RequestBody) BuAuth buAuth){
   return "SUCCESS";
}
```
注：
（1）此时前端直接用$.post()直接请求会有问题，ContentType默认是application/x-www-form-urlencoded。需要使用$.ajaxSetup()标示下ContentType为application/json（或application/xml）。
```js
$.ajaxSetup({ContentType:" application/json"});
$.post("$!{_index}/buAuth/save",{buAuth:JSON.stringify(dataObj),menuIds:menu_ids},function(result){});
```
（2）可以使用@ResponseBody传递数组，如下举例（做为整理直接引用其他博客例子）
```js
var saveDataAry=[];
var data1={"userName":"test","address":"gz"};
var data2={"userName":"ququ","address":"gr"};
saveDataAry.push(data1);
saveDataAry.push(data2);
$.ajax({
    type:"POST",
    url:"user/saveUser",
    dataType:"json",
    contentType:"application/json",
    data:JSON.stringify(saveData),
    success:function(data){ }
});
```
```java
@RequestMapping(value="saveUser", method={RequestMethod.POST})
@ResponseBody
public void saveUser(@RequestBody List<User> users) {
   userService.batchSave(users);
}
```
（3）Controller中的同一个方法只能使用@ResponseBody标记一个参数。也即是说无法直接通过该方法同时传递多个对象，不过可以间接通过设置一个中间pojo对象（设置不同的属性）来达到传递多个对象的效果。举例如下：
```js
var buAuthPage = {
    buAuth :   data,
    menuInfo : {code:"100"}
};
$.ajax({
    type: "POST",
    url: "$!{_index}/buAuth/save5",
    data: JSON.stringify(buAuthPage),
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function(data){
    }
});
```
```java
public class BuAuthPage {
    BuAuth buAuth;
    MenuInfo menuInfo;

    public BuAuth getBuAuth() {
        return buAuth;
    }
    public void setBuAuth(BuAuth buAuth) {
        this.buAuth = buAuth;
    }
    public MenuInfo getMenuInfo() {
        return menuInfo;
    }
    public void setMenuInfo(MenuInfo menuInfo) {
        this.menuInfo = menuInfo;
    }
}
```
```java
@RequestMapping(value = "buAuth/save5")
@ResponseBody
public String save5(@RequestBody BuAuthPage buAuthPage){
    return "SUCCESS";
}
```




