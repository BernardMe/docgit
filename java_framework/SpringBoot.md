

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



## SpringBoot之MVC配置（WebMvcConfigurer详解）
1：提示说明
　　其实在Spring Boot 1.5版本都是靠重写`WebMvcConfigurerAdapter`的方法来添加自定义拦截器，消息转换器等。但是到了SpringBoot2.0之后，WebMvcConfigurerAdapter被标记为@Deprecated（弃用）。官方推荐直接实现WebMvcConfigurer或者直接继承WebMvcConfigurationSupport，

2：MVC配置简要
说MVC配置，其实就是说在WebMvcConfigurer接口提供了很多种自定义配置，需要我们自定义配置，其常用配置如下：
    1：addInterceptors（拦截器配置）
        这个方法可用于配置拦截器。
    2：addCorsMappings（全局跨域处理）
        这个方法用来配置跨域访问的规则。
    3：addViewControllers（注册视图控制器）
        这个方法可以注册一个或多个视图控制器，让我们写的地址可以对应一个资源文件，如html文件
    4：addResourceHandlers（配置静态资源处理）
        方法可用于配置静态资源处理器。可以在客户端直接访问静态资源信息

2.1 拦截器配置
在SpringBoot中，我们可以使用拦截器进行统一的前置和后置处理。
拦截器可以用于日志记录、权限检查、性能监控、事务控制等方面，是一个非常重要的组件。
要在SpringBoot中实现拦截器，则首先要创建一个实现HandlerInterceptor接口的拦截器类。
该接口定义了三个方法，分别是preHandle、postHandle和afterCompletion，用于在请求处理前、请求处理后和请求完成后进行处理。
HandlerInterceptor接口方法详解：
    ①：preHandler
        在请求处理之前被调用。该方法在Interceptor类中最先执行，用来进行一些前置初始化操作或是对当前请求做预处理，
        也可以进行一些判断来决定请求是否要继续进行下去。该方法的返回值是Boolean类型，当它返回false时，表示请求结束，
        后续的Interceptor和Controller都不会再执行；当它返回为true时会继续调用下一个Interceptor的preHandle方法，
        如果已经是最后一个Interceptor的时候就会调用当前请求的Controller方法。
    ②：postHandler
        在请求处理完成之后调用。也就是Controller方法调用之后执行，但是它会在DispatcherServlet进行视图返回渲染之前被调用，
        所以我们可以在这个方法中对Controller处理之后的ModelAndView对象进行操作。
    ③：afterCompletion
        在整个请求结束后调用。就是对应的Interceptor类的postHandler方法返回true时才执行。就是说该方法将在整个请求结束之后，
        也就是在DispatcherServlet渲染了对应的视图之后执行。此方法主要用来进行资源清理。
注：官方其实不建议我们非要把3个方法都重写，我们只要对需要的方法重写接口，就比如大部分项目只需要重写preHandler方法

示例代码 实现拦截器接口（用于配置拦截器）
```JAVA
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 这里我自定义了一个拦截器的拦截规范，后面需要配置到WebMvcConfigurer
 * 我们可以配置多个拦截器，到时候全部配置到WebMvcConfigurer里
 * 注：这里我定义的拦截器就当权限权限路径拦截（具体项目里我们可以起一个见名知意的拦截器 如：PermissionInterceptor）
 *
 * @author Anhui OuYang
 * @version 1.0
 **/
@Component  // 加载Bean容器里
public class MyInterceptor implements HandlerInterceptor {

    private final Logger log = LoggerFactory.getLogger(this.getClass());

    /***
     * 在请求处理前进行调用（Controller方法调用之前）
     * 可以在这一阶段进行全局权限校验等操作
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        log.info("【preHandle】在请求处理前进行调用，自定义拦截器被执行。。。。");
        // 这下面我们可以进行权限校验，校验token操作.....
        // .....
        //上面的代码执行完，若可以放行本次请求则一定要返回true，这样才会到达Controller
        return true;
    }

    /***
     * 请求处理之后进行调用，但是在视图被渲染之前（Controller方法调用之后）
     * 可以在这个阶段来操作 ModelAndView
     */
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
                           ModelAndView modelAndView) throws Exception {
        log.info("【postHandle】请求处理之后进行调用，自定义拦截器被执行。。。。");
    }

    /***
     * 在整个请求结束之后被调用，也就是在DispatcherServlet渲染了对应的视图之后执行，主要用于资源清理工作。
     */
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
                                Object handler, Exception ex) throws Exception {
        log.info("【afterCompletion】在整个请求结束之后被调用，自定义拦截器被执行。。。。");
    }
}
```

我们配置完拦截器之后，这时拦截器只是一个未被注册的普通类，这时需要把一个或者多个拦截器注册到WebMvcConfigurer

InterceptorRegistry类方法介绍：
    ①：addInterceptor
        该方法用于向拦截器链中添加一个拦截器。interceptor参数为待添加的拦截器对象，可以是自定义的拦截器类或Spring提供的预置
        拦截器。返回值为InterceptorRegistration对象，用于进一步配置该拦截器的属性。
    ②：addWebRequestInterceptor
        该方法用于向WebRequest拦截器链中添加一个拦截器。interceptor参数为待添加的拦截器对象，
        可以是自定义的WebRequestInterceptor类或者Spring提供的预置拦截器。
        也是返回值为InterceptorRegistration对象，用于进一步配置该拦截器的属性。
    ③：getInterceptors
        用于获取当前已经添加到拦截器链中的所有拦截器，返回值为List<HandlerInterceptor>对象，表示拦截器列表。
InterceptorRegistration类方法介绍：
    ①：order
        该方法用于设置拦截器的执行顺序，即在拦截器链中的位置。order参数为一个整数，值越小表示越先执行。
    ②：addPathPatterns
        该方法用于设置需要拦截的请求路径模式，即满足哪些请求路径时才会触发该拦截器。若"/**"则拦截全部；
        传入的参数是一个字符串数组，包含多个Ant风格的路径模式，例如 "/api/**"、"/user/*"等。
    ③：excludePathPatterns
        该方法用于设置不需要拦截的请求路径模式，即满足哪些请求路径时不会触发该拦截器。一般不拦截，如登录或者Swagger等
        传入的参数是一个字符串数组，包含多个Ant风格的路径模式，例如 "/api/login"、"/user/login"等。
    ④：pathMatcher
        该方法用于设置该拦截器所使用的PathMatcher实例，从而可以自定义路径匹配逻辑。

```JAVA
@Configuration  // 一定要配置为配置类
@RequiredArgsConstructor
public class WebMvcConfig implements WebMvcConfigurer {

    // 属性注入（使用构造器注入，通过@RequiredArgsConstructor注解生成必要的构造器）
    private final MyInterceptor myInterceptor;

    /***
     * 配置拦截器信息
     * @param registry 拦截器注册表
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {

        // 配置myInterceptor的拦截规范（如拦截的路径等等）
        InterceptorRegistration interceptorA = registry.addInterceptor(myInterceptor);

        // 设置拦截器的配置规则
        interceptorA
                // 指定拦截器的执行顺序。值越小，越先执行拦截器(但是得整型)。
                .order(1)
                // 设置需要拦截的路径（这里拦截所有的路径）
                .addPathPatterns("/api/**", "/user/*", "/**")
                // 设置拦截器的放行资源（代表不拦截）
                // 设置登录放行
                .excludePathPatterns("/login")
                // 设置Swagger访问放行
                .excludePathPatterns("/swagger-ui.html/**", "/swagger-ui.html", "/swagger-ui.html#/**")
                // 如资源文件放行
                .excludePathPatterns("/doc.html", "classpath:/META-INF/resources/");
        // 谨慎使用放行"/**"，这代表全部放行了，那么拦截器就相当于无效配置
        //.excludePathPatterns("/**");

        // 若有多个拦截器则在下面需要配置多个(如下面interceptorB，我们需要对这个进行路径拦截的配置)
        // InterceptorRegistration interceptorB = registry.addInterceptor(自定义的拦截器对象);
    }
}
```
注：拦截的路径或者放行的路径是以Controller开始的，如我们在application.yml配置的地址前缀则不包含


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




