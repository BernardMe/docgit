



## Srpring task(定时任务)

### cron表达式

配置说明

字段     |允许值         | 允许的特殊字符
:--------|--------------:|:---------------------
秒		 |0-59          |-*/
分		 |0-59          |-*/
小时	 |0-23 	         | -*/
日期	 |1-31 	         | -*? / L W C
月份	 |1-12或JAN-DEC  | - * /
星期	 |1-7或MON-FRI   | - * ? / L C #
年(可选) |留空,1970-2099| -*/
- 区间
*通配符
?你不想设置那个字段(? 号只能用在日期和星期上，但是不能在这两个域上同时使用)
`#`字符仅能用于周域中。它用于指定月份中的第几周的哪一天。例如，如果你指定周域的值为 6#3，它意思是某月的第三个周五 (6=星期五，#3意味着月份中的第三周)


cron表达式              |含义
:--------------------- |:---------
0 0 12 * * *           |每天中午12点触发
0 15 10 * * *          |每天早上10:15触发
0 15 10 * * * 2005     |2005年的每天早上10：15触发
0 0/1 14 * * *         |每天从下午2点开始到2点59分每分钟一次触发
0 0/5 14 18 * * *      |每天的下午2点至2：55和6点至6点55分两个时间段内每5分钟一次触发
0 0/5 14 * * *		   |每天从下午2点开始到2：55分结束每5分钟一次触发
0 0-5 14 * * *         |每天14:00至14:05每分钟一次触发
0 10 44 14 ? 3 WED     |三月的每周三的14：10和14：44触发
0 15 10 ? * MON-FRI	   |每个周一、周二、周三、周四、周五的10：15触发
0 15 10 ? * 6#3        |每月的第三个星期五上午10:15触发




### XML配置方式z`

1.1在xml里加入task的命名空间
```xml
<beans xmlns:task="http://www.springframework.org/schema/task"  
	xsi:schemaLocation="http://www.springframework.org/schema/beans     
    http://www.springframework.org/schema/beans/spring-beans.xsd  
    http://www.springframework.org/schema/task     
    http://www.springframework.org/schema/task/spring-task-3.0.xsd"
>
</beans>
```


```xml

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"  
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:task="http://www.springframework.org/schema/task"  
    xsi:schemaLocation="http://www.springframework.org/schema/beans     
    http://www.springframework.org/schema/beans/spring-beans.xsd  
    http://www.springframework.org/schema/task     
    http://www.springframework.org/schema/task/spring-task-3.0.xsd"> 
	<!-- 定时器 -->
    <bean name="TitleIconController" class="com.nationsky.activity.flyingstart.controller.TitleIconController" />

    <task:scheduled-tasks>
	    <!--每周六 4点查询 商城标题图-->
	    <task:scheduled ref="TitleIconController" method="getTitleIconList" cron="0 7 18 ? * SAT"/>

   	</task:scheduled-tasks>   
</beans>
```

### 注解配置方式
2.1在xml里加入task的命名空间
```xml
<beans xmlns:task="http://www.springframework.org/schema/task"  
	xsi:schemaLocation="http://www.springframework.org/schema/beans     
    http://www.springframework.org/schema/beans/spring-beans.xsd  
    http://www.springframework.org/schema/task     
    http://www.springframework.org/schema/task/spring-task-3.0.xsd"
>
</beans>
```

2.2 启用注解驱动的定时任务
```xml
<task:annotation-driven scheduler="myScheduler"/>   
```

2.3 配置定时任务的线程池
推荐配置线程池，若不配置多任务下会有问题。
```xml
<task:scheduler id="myScheduler" pool-size="5" />
```

2.4 写我们的定时任务
@Scheduled注解为定时任务，cron表达式里写执行的时机
```java
/** 
 * Spring3 @Scheduled 演示 
 * @author ZYWANG 2011-3-9 
 */  
@Component  
public class SpringTaskDemo {  
  
    @Scheduled(fixedDelay = 5000)  
    void doSomethingWithDelay(){  
        System.out.println("I'm doing with delay now!");  
    }  
      
    @Scheduled(fixedRate = 5000)  
    void doSomethingWithRate(){  
        System.out.println("I'm doing with rate now!");  
    }  
      
    @Scheduled(cron = "0/5 * * * * *")  
    void doSomethingWith(){  
        System.out.println("I'm doing with cron now!");  
    }  
}  
```

注意：
Spring 3.0.5
创建一个Java类，添加一个无参无返回值的方法，在方法上用@Scheduled注解修饰一下；
在Spring配置文件中添加三个<task:**** />节点；

