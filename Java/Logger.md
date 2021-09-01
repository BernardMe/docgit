

## 总结

### e.printStackTrace()不会打印异常堆栈到日志

在Java中，通常情况下，需要将异常堆栈信息输出到日志中，这样便于纠错及修正Bug，而多数情况下，大家最常用的是使用e.printStackTrace()直接打印堆栈信息完事，这并不是值的推荐的做法。

当出现异常时，`调用e.printStackTrace();其实相当于什么都没做，同时也不会把异常信息输出到日志文件中`
使用log.error(e.getMessage());只能够输出异常信息，但是并不包括异常堆栈，所以无法追踪出错的源点
使用log.error(e);除了输出异常信息外，还能输出异常类型，但是同样不包括异常堆栈，该方法doc说明为：Logs a message object with the ERROR level.显然并不会记录异常堆栈信息
当然也可以自己手动写个工具类，来挨个输出e.getStackTrace();获得的堆栈信息，显然繁琐麻烦
其实在log4j中只需要这样调用，就可以获得异常及堆栈信息log.error(Object var1, Throwable var2);，该方法doc说明为：Logs a message at the ERROR level including the stack trace of the Throwable t passed as parameter.

## slf4j(Simple Logging Facade for Java)

### 阿里Java代码规范引入slf4j
>【强制】应用中不可直接使用日志系统（Log4j、Logback）中的API，而应依赖使用日志框架
SLF4J中的API，使用门面模式的日志框架，有利于维护和各个类的日志处理方式统一。
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
private static final Logger logger = LoggerFactory.getLogger(Abc.class);

大概意思就是说 SLF4J 是一个日志抽象层，允许你使用任何一个日志系统，并且可以随时切换还不需要动到已经写好的程序（我特么是真改过整个项目的所有打印日志的代码，累死...），这对于第三方组件的引入的不同日志系统来说几乎零学习成本了，况且它的优点不仅仅这一个而已;
还有简洁的占位符的使用和日志级别的判断，众所周知的日志读写一定会影响系统的性能，但这些特性都是对系统性能友好的


## log4j

### 配置文件

1.1 配置文件
Log4j可以通过java程序动态设置，该方式明显缺点是：如果需要修改日志输出级别等信息，则必须修改java文件，然后重新编译，很是麻烦；
log4j也可以通过配置文件的方式进行设置，目前支持两种格式的配置文件：
?xml文件
?properties文件（推荐）
下面是一个log4j配置文件的完整内容：
复制代码 代码如下:
```shell
log4j.rootCategory=INFO, stdout
log4j.rootLogger=info, stdout

### stdout
log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.Target=System.out
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=%d{ABSOLUTE} %5p - %m%n

### set package
log4j.logger.org.springframework=info
log4j.logger.org.apache.catalina=info
log4j.logger.org.apache.commons.digester.Digester=info
log4j.logger.org.apache.catalina.startup.TldConfig=info
log4j.logger.chb.test=debug
```

1.2 配置根Logger
根logger主要定义log4j支持的日志级别及输出目的地，其语法为：
log4j.rootLogger = [ level ] , appenderName, appenderName, …
其中，level 是日志记录的优先级，分为OFF、FATAL、ERROR、WARN、INFO、DEBUG、ALL或者自定义的级别。
建议只使用四个级别，优先级从高到低分别是ERROR、WARN、INFO、DEBUG。
appenderName指定日志信息输出到哪个地方，可同时指定多个输出目的地。

1.3 配置输出目的地Appender
Appender主要定义日志信息输出在什么位置，主要语法为：
复制代码 代码如下:
```shell
log4j.appender.appenderName=classInfo
log4j.appender.appenderName.option1=value1

log4j.appender.appenderName.optionN=valueN
```

Log4j提供的appender有以下几种：
org.apache.log4j.ConsoleAppender（控制台）， 
org.apache.log4j.FileAppender（文件）， 
org.apache.log4j.DailyRollingFileAppender（每天产生一个日志文件），
org.apache.log4j.RollingFileAppender（文件大小到达指定尺寸的时候产生一个新的文件） 
org.apache.log4j.WriterAppender（将日志信息以流格式发送到任意指定的地方）



### Log4j Threshold属性指定输出等级
有时候我们需要把一些报错ERROR日志单独存到指定文件 ，这时候，Threshold属性就派上用场了；

Threshold属性可以指定日志level 

Log4j根据日志信息的重要程度，分OFF、FATAL、ERROR、WARN、INFO、DEBUG、ALL

指定某个appender的Threshold为WARN，那这个appender输出的日志信息就是WARN级别以及WARN以上的级别； 

`假如我们指定的是ERROR，那这个就输出ERROR或者信FATAL日志息；`

当然这里有个提前  rootLogger里配置的level比如小于Threshold层级  否则无效 还是按照总的rootLogger里的level来输出，一般我们实际实用的话 rootLogger里配置DEBUG，然后某个文件专门存储ERRO日志，就配置下Threshold为ERROR，这个就是我们的最佳实践，不要乱七八糟瞎配置；


### 使用步骤:
- 导入log4j-xxx.jar
- 在src下新建log4j.properties(路径和名称都不允许改变)
	+ ConversionPattern :写表达式
	+ log4j.appender.LOGFILE.File 文件位置及名称(日志文件扩展名.log)


### 输出级别, 目的地
- fatal 致命错误，无法解决
- error 错误
- warn 警告
- info 消息在粗粒度级别上突出强调应用程序的运行过程。打印一些你感兴趣的或者重要的信息，这个可以用于生产环境中输出程序运行的一些重要信息，但是不能滥用，避免打印过多的日志。
- debug 指出细粒度信息事件对调试应用程序是非常有帮助的，主要用于开发过程中打印一些运行信息。
- 
 fatal(致命错误)   error (错误)  warn (警告)  info(普通信息)  debug(调试信息)
 在log4j.properties的第一行中控制输出级别

### log4j输出目的地
5.1 在一行控制输出目的地


### pattern中常用几个表达式
6.1 %C   包名+类名
6.2%d{YYYY-MM-dd HH:mm:ss}		时间
6.3%L		行号
6.4%m   信息
6.5%n		换行

### log4j 的rootLogger与rootCategory的区别
一句话

rootLogger是新的使用名称，对应Logger类

rootCategory是旧的使用名称，对应原来的Category类

Logger类是Category类的子类，所以，rootCategory是旧的用法，不推荐使用