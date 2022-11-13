

# SpringBoot


## 入门介绍
入门Spring Boot的入门介绍，相关的需要理解的概念：

Spring Boot父级依赖的概念
起步依赖 spring-boot-starter-xx的概念
应用入口类的作用



## SpringBoot为什么没有web.xml了

>随着 spring 的普及，配置逐渐演变成了两种方式—java configuration 和 xml 配置共存。现如今，springboot 的普及，java configuration 成了主流，xml 配置似乎已经“灭绝”了。不知道你有没有好奇过，这中间都发生了哪些改变，web.xml 中的配置项又是被什么替代项取代了？


### servlet3.0 新特性
Servlet 3.0 作为 Java EE 6 规范体系中一员，随着 Java EE 6 规范一起发布。该版本在前一版本（Servlet 2.5）的基础上提供了若干新特性用于简化 Web 应用的开发和部署。其中一项新特性便是提供了无 xml 配置的特性。

servlet3.0 首先提供了 @WebServlet，@WebFilter 等注解，这样便有了抛弃 web.xml 的第一个途径，凭借注解声明 servlet 和 filter 来做到这一点。

除了这种方式，servlet3.0 规范还提供了更强大的功能，可以在运行时动态注册 servlet ，filter，listener。以 servlet 为例，过滤器与监听器与之类似


### SpringBoot 如何加载 Servlet？

读到这儿，你已经阅读了全文的 1/2。springboot 对于 servlet 的处理才是重头戏，
其一，是因为 springboot 使用范围很广，很少有人用 spring 而不用 springboot 了；
其二，是因为它没有完全遵守 servlet3.0 的规范！

是的，前面所讲述的 servlet 的规范，无论是 web.xml 中的配置，还是 servlet3.0 中的 ServletContainerInitializer 和 springboot 的加载流程都没有太大的关联。按照惯例，先卖个关子，先看看如何在 springboot 中注册 servlet 和 filter，再来解释下 springboot 的独特之处。

注册方式一：servlet3.0注解+@ServletComponentScan

注册方式二：RegistrationBean

### @SpringBoot注解

```java

@Tatget
@Runtime
@Document
@Inherited
@SpringBootConfigration
@EnableAutoConfigration
@ConponentScan(excludedFilters = {
	@Filter(type=FilterType.CUSTOM, classes=TypeExcludeFilter.class)
	@Filter(type=FilterType.CUSTOM, classes=AutoConfigrationExcludedFilter.class)})

public @interface SpringBootApplication

```
其中@SpringBootApplication注解主要组合了 @Configuration、@EnableAutoConfiguration、 @ComponentScan 。

如果不使用@SpringBootApplication注解,则可以使用在入口类上直接使用@Configuration、@EnableAutoConfiguration、@ComponentScan也能达到相同效果。


其中几个注解的作用大致说一下:

@Configuration:是做类似于spring xml 工作的注解 标注在类上,类似与以前的`**.xml`配置文件。

@EnableAutoConfiguration:spring boot自动配置时需要的注解,会让Spring Boot根据类路径中的jar包依赖为当前项目进行自动配置。同时,它也是一个组合注解



## 外部化配置

### 外部化配置的优先级顺序如下：

Devtools 全局配置：当 devtools 启用时，$HOME/.config/spring-boot
测试类中的 @TestPropertySource
测试中的 properties 属性：在 @SpringBootTest 和 用来测试特定片段的测试注解
命令行参数
SPRING_APPLICATION_JSON 中的属性：内嵌在环境变量或系统属性中的 JSON
ServletConfig 初始化参数
ServletContext 初始化参数
java:comp/env 中的 JNDI 属性
Java 系统属性：System.getProperties()
操作系统环境变量
随机值（RandomValuePropertySource）：`random.*属性`
jar 包外的指定 profile 配置文件：application-{profile}.properties
jar 包内的指定 profile 配置文件：application-{profile}.properties
jar 包外的默认配置文件：application.properties
jar 包内的默认配置文件：application.properties
代码内的 @PropertySource注解：用于 @Configuration 类上
默认属性：通过设置 SpringApplication.setDefaultProperties 指定

注意：以上用 properties 文件的地方也可用 yml文件



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


源码分析

那么我们来总结下@SpringBootApplication:就是说，他已经把很多东西准备好，具体是否使用取决于我们的程序或者说配置，那我们到底用不用？那我们继续来看一行代码

```java
public static void main(String[] args) {
    SpringApplication.run(StartEurekaApplication.class, args);
}
```
那我们来看下在执行run方法到底有没有用到那些自动配置的东西，比如说内置的Tomcat，那我们来找找内置Tomcat，我们点进run

```java
public static ConfigurableApplicationContext run(Object[] sources, String[] args) {
    return new SpringApplication(sources).run(args);
}
```
然后他调用又一个run方法，我们点进来看，

```java

public ConfigurableApplicationContext run(String... args) {
    //计时器
    StopWatch stopWatch = new StopWatch();
    stopWatch.start();
    ConfigurableApplicationContext context = null;
    Collection<SpringBootExceptionReporter> exceptionReporters = new ArrayList();
    this.configureHeadlessProperty();
    //监听器
    SpringApplicationRunListeners listeners = this.getRunListeners(args);
    listeners.starting();

    Collection exceptionReporters;
    try {
        ApplicationArguments applicationArguments = new DefaultApplicationArguments(args);
        ConfigurableEnvironment environment = this.prepareEnvironment(listeners, applicationArguments);
        this.configureIgnoreBeanInfo(environment);
        Banner printedBanner = this.printBanner(environment);
	//准备上下文
        context = this.createApplicationContext();
        exceptionReporters = this.getSpringFactoriesInstances(SpringBootExceptionReporter.class, new Class[]{ConfigurableApplicationContext.class}, context);
	//预刷新context
        this.prepareContext(context, environment, listeners, applicationArguments, printedBanner);
	//刷新context
        this.refreshContext(context);
	//刷新之后的context
        this.afterRefresh(context, applicationArguments);
        stopWatch.stop();
        if (this.logStartupInfo) {
            (new StartupInfoLogger(this.mainApplicationClass)).logStarted(this.getApplicationLog(), stopWatch);
        }

        listeners.started(context);
        this.callRunners(context, applicationArguments);
    } catch (Throwable var10) {
        this.handleRunFailure(context, var10, exceptionReporters, listeners);
        throw new IllegalStateException(var10);
    }

    try {
        listeners.running(context);
        return context;
    } catch (Throwable var9) {
        this.handleRunFailure(context, var9, exceptionReporters, (SpringApplicationRunListeners)null);
        throw new IllegalStateException(var9);
    }
}
```
那我们关注的就是refreshContext(context); 刷新context，我们点进来看

```java

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




