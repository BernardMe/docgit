

## SpringMVC


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


## SpringMVC 拦截器

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

