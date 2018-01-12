

## Maven本质
Maven本质上是一个插件框架，它的核心并不执行任何具体的构建任务，所有这些任务都交给插件来完成，例如编译源代码是由maven- compiler-plugin完成的
进一步说，每个任务对应了一个插件目标（goal），每个插件会有一个或者多个目标，
例如maven- compiler-plugin的compile目标用来编译位于src/main/java/目录下的主源码，testCompile目标用来编译位于src/test/java/目录下的测试源码

### 2种方式调用Maven插件目标
用户可以通过两种方式调用Maven插件目标。
第一种方式是将插件目标与生命周期阶段（lifecycle phase）绑定，这样用户在命令行只是输入生命周期阶段而已，
>例如Maven默认将maven-compiler-plugin的compile目标与compile生命周期阶段绑定，因此命令mvn compile实际上是先定位到compile这一生命周期阶段，然后再根据绑定关系调用maven-compiler-plugin的compile目标。

第二种方式是直接在命令行指定要执行的插件目标，
>例如`mvn archetype:generate` 就表示调用maven-archetype-plugin的generate目标，这种带冒号的调用方式与生命周期无关。

### 重点
而Maven所做的工作，『就是把网络上一个地址映射到你本地一个地址』然后使用一个『坐标』的概念拼接出来这个路径。其实质就是`一个本地文件夹和云盘的同步`


## Maven的pom.xml文件

### Maven的中央仓库
地址: http://central.maven.org/maven2/

这个就是Maven在网络上的中央仓库，说白了就是个文件夹，里面存了所有在Maven上发布的Jar包


### 配置文件的解析
Maven的配置文件是个xml文件，其具体有什么标签，代表什么意思，可以去Maven的官方网站文档查询，这里做简单的解释。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="
         http://maven.apache.org/POM/4.0.0
         http://maven.apache.org/maven-v4_0_0.xsd
         ">
    <modelVersion>4.0.0</modelVersion>
    <groupId>坐标组</groupId>
    <artifactId>坐标名</artifactId>
    <version>坐标版本号</version>
    <packaging>Target格式</packaging>
    <dependencies>需要加载哪些Jar包</dependencies>
    <build>编译和生成Target目录</build>
</project>
```
project节点： 该节点代表一个工程或者是一个模块，是pom文件的最外层节点，其下有9个基本节点
坐标节点：指的是「groupId」「artifactId」「version」这三个节点，定义了目录信息
packaging节点：项目编译后打包成Target时生成的格式
dependencies节点： 重点的重点！规定了Project要加载哪些Jar包
build节点：编译打包生成相关配置



## Maven项目的应用

### Maven项目目录结构(jar类型)
- src/main/java真实目录的快捷目录,写java代码
- src/main/resources 快捷目录
	+ 存放配置文件.
	+ 虽然看见resources但是里面所有配置文件最终会被编译放入到classes类路径.
- src/test/java 写测试java代码
- src/text/resources 测试的配置文件夹
- pom.xml maven的配置文件
	+ 当前项目所依赖的其他项目或jar或插件等

 pom.xml maven的配置文件

### Maven项目之间的关系

- 依赖关系
	+ 标签<dependency>把另一个项目的jar引入到当过前项目
	+ 自动下载另一个项目所依赖的其他项目

- 继承关系
- 聚合关系

### maven用法
3.3 web工程
创建一个简单的web项目，只需要修 -DarchetypeArtifactId为maven-archetype-webapp即可，如下命令

```sehll
mvn archetype:generate -DgroupId=com.bernard -DartifactId=MemoSSH -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false
```


### Maven私服使用办法

前提:已经配置JDK环境变量

1. 把压缩包解压到任意非中文目录中

2. 根据自己的系统选择对应的版本
D:\nexus\soft\nexus-2.12.0-01\bin\jsw

3. 运行install-nexus.bat 在系统中注册服务

4. 注册后可以通过start-nexus.bat/stop-nexus.bat 开启服务和关闭服务
也可以在系统服务中开启关闭服务

	4.1 uninstall-nexus.bat 表示卸载服务

5. 在浏览器输入   http://localhost:8081/nexus 进入主界面

6. 在主界面右上角log in 进行登录,默认用户名和密码是 
	用户名:admin
	密码:admin123

### Nexus仓库分类
hosted 宿主仓库
主要用于部署无法从公共仓库获取的构件(如Oracl的JDBC驱动)以及自己或第三方的项目构件，是私有仓库的一部分，私有仓库还包括从代理仓库下载过来的构件
proxy 代理仓库
代理公共的远程仓库
virtual 虚拟仓库
用于适配Maven1
group 仓库组
Nexus通过仓库组的概念统一管理多个仓库，这样我们在项目中就直接请求仓库组即可请求到仓库组管理的多个仓库

### Maven3中ojdbc驱动问题
由于Oracle授权问题，Maven3不提供Oracle JDBC driver，为了在Maven项目中应用Oracle JDBC driver,必须手动添加到本地仓库。

此文档用的是Oracle 11g.


### POM.xml

#### 资源拷贝插件
```xml
<!-- 资源拷贝插件配置 -->
<resources>
    <resource>
        <directory>src/main/java</directory>
        <includes>
            <include>**/*.xml</include>
        </includes>
    </resource>
    <resource>
        <directory>src/main/resources</directory>
        <includes>
            <include>**/*.xml</include>
            <include>**/*.properties</include>
        </includes>
    </resource>
</resources>
```
