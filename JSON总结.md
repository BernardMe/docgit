



# JSON

`JSON采用完全独立于程序语言的文本格式，但是也使用了类C语言的习惯（包括C, C++, C#, Java, JavaScript, Perl, Python等）。这些特性使JSON成为理想的数据交换语言`



## JSON基于两种结构：
JSON[1] 结构有两种结构[2]

json简单说就是javascript中的对象和数组，所以这两种结构就是对象和数组两种结构，通过这两种结构可以表示各种复杂的结构

1、对象：对象在js中表示为“{}”括起来的内容，数据结构为 {key：value,key：value,...}的键值对的结构，在面向对象的语言中，key为对象的属性，value为对应的属性值，所以很容易理解，取值方法为 对象.key 获取属性值，这个属性值的类型可以是 数字、字符串、数组、对象几种。
2、数组：数组在js中是中括号“[]”括起来的内容，数据结构为 ["java","javascript","vb",...]，取值方式和所有语言中一样，使用索引获取，字段值的类型可以是 数字、字符串、数组、对象几种。

```js
{
    "animals": {
        "dog": [
            {
                "name": "Rufus",
                "age":15
            },
            {
                "name": "Marty",
                "age": null
            }
        ]
    }
}
```
经过对象、数组2种结构就可以组合成复杂的数据结构了。



## 首先理解JSONArrary和JsonObject
 

### JSONObject和JSONArray的数据表示形式

JSONObject的数据是用 {  } 来表示的，

例如：
`{ "id" : "123", "courseID" : "huangt-test", "title" : "提交作业", "content" : null  }`

而JSONArray，顾名思义是由JSONObject构成的数组，用  [ { } , { } , ......  , { } ]  来表示

例如：   
`[ {  "id" : "123", "courseID" : "huangt-test", "title" : "提交作业" }  ,  {  "content" : null, "beginTime" : 1398873600000  "endTime" } ]`

表示了包含2个JSONObject的JSONArray。

可以看到一个很明显的区别，
`一个最外面用的是 {  }  ，一个最外面用的是 [  ]`




JSON(JavaScript Object Notation)一种简单的数据格式，比xml更轻巧。JSON是JavaScript原生格式，就是说在JavaScript中处理JSON数据不需要任何特殊的API或工具包。

## JSON规则：
对象是一个无序的“键值对”集合。

## JSON格式

简单说，每个JSON对象，就是一个值。要么是简单类型的值，要么是复合类型的值，但是只能是一个值，不能是两个或更多的值。这就是说，每个JSON文档只能包含一个值。

###JSON对值的类型和格式有严格的规定。

- 复合类型的值只能是数组或对象，不能是函数、正则表达式对象、日期对象。

- 简单类型的值只有四种：字符串、数值（必须以十进制表示）、布尔值和null（不能使用NaN, Infinity, -Infinity和undefined）。

- 字符串必须使用双引号表示，不能使用单引号。

- 对象的键名必须放在双引号里面。

- 数组或对象最后一个成员的后面，不能加逗号。




## JSON序列化和反序列化

`序列化：将数据结构或对象转换成二进制串的过程。`

`反序列化：将在序列化过程中所生成的二进制串转换成数据结构或对象的过程。`


### alibaba/FastJson处理泛型反序列化

在fastjson中提供了一个用于处理泛型反序列化的类TypeReference。

```java
import com.alibaba.fastjson.TypeReference;

List<VO> list = JSON.parseObject("...", new TypeReference<List<VO>>() {});
```

如下写法有更好的性能
```java
import com.alibaba.fastjson.TypeReference;

final static Type type = new TypeReference<List<VO>>() {}.getType();

List<VO> list = JSON.parseObject("...", type);
```

在这里例子中，通过TypeReference能够解决List中T的类型问题。



### alibaba/FastJson中@JSONField的作用对象:

1. Field

2. Setter 和 Getter方法

FastJson在进行操作时，是根据getter和setter的方法进行的，并不是依据Field进行
