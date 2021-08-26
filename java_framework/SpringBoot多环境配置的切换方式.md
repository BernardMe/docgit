



## profile实现多环境配置的切换有常用的几种实现方式
修改application.properties(yml)
命令行方式
maven的profile方式
@Profile注解方式

### 分别介绍

第一种
修改主配置文件
 springboot中多环境配置文件名需要满足application-{profile}.properties格式，其中{profile}对应你的环境标识，比如:

application-dev.properties：开发环境 
application-test.properties：测试环境 
application-prod.properties：生产环境
    我们通过不同的环境应用的启动端口不同，来分别测试多环境切换的功能
   

1：添加profile配置文件

    application-dev.properties:

    application-test.properties:

    application-prod.properties:


2：添加主配置文件

    application.properties配置文件中添加spring.profiles.active属性，指向不同的环境配置：
    spring.profiles.active=dev



第三种
maven的profile方式
 Maven同样也有Profile设置，可在构建过程中针对不同的Profile环境执行不同的操作，包含配置、依赖、行为等。Maven的Profile由 pom.xml 的<Profiles>标签管理。每个Profile中可设置：id(唯一标识), properties(配置属性), activation(自动触发的逻辑条件), dependencies(依赖)等。

1：修改application.properties

    配置文件application.properties中使用占位符填充属性：

spring.profiles.active=@profiles.active@
server.port=@profiles.port@

2：修改pom文件

    应用pom文件中添加profiles配置：
```xml
<profiles>
<profile>
    <!-- 本地开发环境 -->
    <id>dev</id>
    <properties>
 <profiles.active>dev</profiles.active>
 <profiles.port>9090</profiles.port>
    </properties>
    <activation>
 <activeByDefault>true</activeByDefault>
    </activation>
</profile>
<profile>
    <!-- 测试环境 -->
    <id>test</id>
    <properties>
 <profiles.active>test</profiles.active>
 <profiles.port>9091</profiles.port>
    </properties>
</profile>
<profile>
    <!-- 生产环境 -->
    <id>prod</id>
    <properties>
 <profiles.active>prod</profiles.active>
 <profiles.port>9092</profiles.port>
    </properties>
</profile>
</profiles>
```
    <profiles.active>和<profiles.port>分别对应application.properties中的profiles.active和profiles.port属性，执行命令的时候会动态替换。

    在应用目录下执行命令：

mvn clean package -Dmaven.test.skip=true -P dev -e 

