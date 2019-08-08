

# SpringBoot


## 入门介绍
入门Spring Boot的入门介绍，相关的需要理解的概念：

Spring Boot父级依赖的概念
起步依赖 spring-boot-starter-xx的概念
应用入口类的作用

## SpringBoot启动流程

```
组装SpringApplication  --> 设置ApplicationContextInitializer,ApplicationListener和webApplicationType

调用run方法

获取SpringApplicationRunListeners，并启动该listener

--------BEGINNING 过程中出现异常调用handleRunFailure(context, ex, exReporters, listener)-----------

获取ApplicationArguments

设置ConfigurableEnvironment

    if 设置configureIgnoreBeanInfo

    else 创建Bannner

创建Spring容器ConfigurableApplicationContext

准备容器prepareContext

刷新容器refreshContext

完成刷新afterRefresh

调用SpringApplicationRunListeners的started方法

callRunners

--------END 过程中出现异常调用handleRunFailure(context, ex, exReporters, listener)-----------

调用listeners.running(context);
```


### Spring Boot父级依赖的概念

```java
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>1.5.1.RELEASE</version>
    <relativePath/> <!-- lookup parent from repository -->
</parent>
```
这块配置就是Spring Boot父级依赖，有了这个，当前的项目就是Spring Boot项目了，
spring-boot-starter-parent是一个特殊的starter,它用来提供相关的Maven默认依赖


### 起步依赖 spring-boot-starter-xx的概念
Spring Boot提供了很多”开箱即用“的依赖模块，都是以spring-boot-starter-xx作为命名的

### 应用入口类的作用

@SpringBootApplication是Sprnig Boot项目的核心注解，主要目的是开启自动配置



## 基础功能_定时任务

### 创建定时任务

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * Description: 构建执行定时任务
 * Designer: jack
 * Date: 2017/8/10
 * Version: 1.0.0
 */
@Component
public class ScheduledTasks {

    private Logger logger = LoggerFactory.getLogger(ScheduledTasks.class);

    private int fixedDelayCount = 1;
    private int fixedRateCount = 1;
    private int initialDelayCount = 1;
    private int cronCount = 1;

    @Scheduled(fixedDelay = 5000)        //fixedDelay = 5000表示当前方法执行完毕5000ms后，Spring scheduling会再次调用该方法
    public void testFixDelay() {
        logger.info("===fixedDelay: 第{}次执行方法", fixedDelayCount++);
    }

    @Scheduled(fixedRate = 5000)        //fixedRate = 5000表示当前方法开始执行5000ms后，Spring scheduling会再次调用该方法
    public void testFixedRate() {
        logger.info("===fixedRate: 第{}次执行方法", fixedRateCount++);
    }

    @Scheduled(initialDelay = 1000, fixedRate = 5000)   //initialDelay = 1000表示延迟1000ms执行第一次任务
    public void testInitialDelay() {
        logger.info("===initialDelay: 第{}次执行方法", initialDelayCount++);
    }

    @Scheduled(cron = "0 0/1 * * * ?")  //cron接受cron表达式，根据cron表达式确定定时规则
    public void testCron() {
        logger.info("===initialDelay: 第{}次执行方法", cronCount++);
    }

}
```
我们使用@Scheduled来创建定时任务 这个注解用来标注一个定时任务方法。通过看@Scheduled源码可以看出它支持多种参数：

cron：cron表达式，指定任务在特定时间执行；

fixedDelay：表示上一次任务执行完成后多久再次执行，参数类型为long，单位ms；

fixedRate：表示按一定的频率执行任务，参数类型为long，单位ms；

initialDelay：表示延迟多久再第一次执行任务，参数类型为long，单位ms；



### 开启定时任务

```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * Description: 启动类
 * Designer: jack
 * Date: 2017/8/10
 * Version: 1.0.0
 */
@SpringBootApplication
@EnableScheduling
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```
注意这里的 @EnableScheduling 注解，它的作用是发现注解@Scheduled的任务并由后台执行。没有它的话将无法执行定时任务。

引用官方文档原文：
`@EnableScheduling ensures that a background task executor is created. Without it, nothing gets scheduled.`

