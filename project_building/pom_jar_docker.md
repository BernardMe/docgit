<project xmlns="http://maven.apache.org/POM/4.0.0"
		 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		 xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>

	<parent>
		<groupId>com.niceloo.framework</groupId>
		<artifactId>common-parent</artifactId>
		<version>2.0.17-SNAPSHOT</version>
	</parent>

	<!-- 定义项目功能版本 -->
	<groupId>com.youlu</groupId>
	<artifactId>niceloo-revenuesystem</artifactId>
	<version>2021.06.12</version>
	<packaging>jar</packaging>

	<properties>
		<start-class>com.niceloo.rs.RevenueSystemApplication</start-class>
		<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
		<!-- 服务治理 -->
		<dubbo.version>2.6.2</dubbo.version>
		<motan.version>1.1.1</motan.version>
		<!-- ZK-->
		<zookeeper.version>3.4.12</zookeeper.version>
	</properties>


	<!-- 手动指定 -->
	<repositories>
		<repository>
			<id>youlu-nexus</id>
			<url>http://nexus.niceloo.com:11081/repository/maven-public/</url>
			<layout>default</layout>
		</repository>
	</repositories>
	<pluginRepositories>
		<pluginRepository>
			<id>youlu-nexus</id>
			<url>http://nexus.niceloo.com:11081/repository/maven-public/</url>
			<layout>default</layout>
		</pluginRepository>
	</pluginRepositories>


	<!-- 定义项目Jar包依赖 -->
	<dependencies>
		<dependency>
			<groupId>com.niceloo.framework</groupId>
			<artifactId>starter-web</artifactId>
		</dependency>
		<dependency>
			<groupId>com.niceloo.framework</groupId>
			<artifactId>starter-db-dynamic</artifactId>
		</dependency>
		<dependency>
			<groupId>mysql</groupId>
			<artifactId>mysql-connector-java</artifactId>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-test</artifactId>
			<scope>test</scope>
		</dependency>
		<dependency>
			<groupId>com.niceloo.framework</groupId>
			<artifactId>starter-code-gen</artifactId>
			<scope>test</scope>
		</dependency>
		<!--第三方依赖-->
		<dependency>
			<groupId>com.github.pagehelper</groupId>
			<artifactId>pagehelper-spring-boot-starter</artifactId>
			<version>1.3.0</version>
		</dependency>
		<dependency>
			<groupId>commons-beanutils</groupId>
			<artifactId>commons-beanutils</artifactId>
			<version>1.9.4</version>
		</dependency>
		<dependency>
			<groupId>com.alibaba</groupId>
			<artifactId>fastjson</artifactId>
			<version>1.2.76</version>
		</dependency>
		<!--Sql Server-->
		<dependency>
			<groupId>com.microsoft.sqlserver</groupId>
			<artifactId>sqljdbc4</artifactId>
			<version>4.0</version>
		</dependency>
		<!-- poi -->
		<dependency>
			<groupId>org.apache.poi</groupId>
			<artifactId>poi-ooxml</artifactId>
			<version>3.9</version>
		</dependency>
		<!-- https://mvnrepository.com/artifact/com.ctrip.framework.apollo/apollo-client -->
		<dependency>
			<groupId>com.ctrip.framework.apollo</groupId>
			<artifactId>apollo-client</artifactId>
			<version>1.7.0</version>
		</dependency>
	</dependencies>

	
	
	<!-- 定义项目编译 -->
	<build>
		<finalName>revenuesystem</finalName>
		<!-- 构建插件 -->
		<plugins>
			<!-- 管理编译的JDK版本 -->
			<plugin>
				<artifactId>maven-compiler-plugin</artifactId>
				<version>3.8.0</version>
				<configuration>
					<source>1.8</source>
					<target>1.8</target>
					<encoding>UTF-8</encoding>
					<testIncludes>
						<testInclude>none</testInclude>
					</testIncludes>
				</configuration>
			</plugin>

			<!-- 定义项目编译输出的文件 -->
			<plugin>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-maven-plugin</artifactId>
                <!--加入下面两项配置-->
                <executions>
                    <execution>
                        <goals>
                            <goal>repackage</goal>
                        </goals>
                    </execution>
                </executions>
				<configuration>
					<includeSystemScope>true</includeSystemScope>
					<mainClass>com.niceloo.rs.RevenueSystemApplication</mainClass>
					<outputDirectory>${project.build.directory}</outputDirectory>
				</configuration>
			</plugin>


		</plugins>
	</build>

	<!-- 定义maven仓库 -->
	<distributionManagement>
		<repository>
			<id>youlu</id>
			<name>优路maven仓库私服</name>
			<url>${maven.repo}</url>
		</repository>
	</distributionManagement>

	<profiles>
		<profile>
			<id>dev</id>
			<properties>
				<maven.repo>http://nexus.niceloo.com:11081/repository/maven-releases/</maven.repo>
				<docker.repo>nexus.niceloo.com:8083</docker.repo>
			</properties>
		</profile>

		<profile>
			<id>prod</id>
			<properties>
				<maven.repo>http://nexus.niceloo.com:11081/repository/maven-releases/</maven.repo>
				<docker.repo>nexus.niceloo.com:8083</docker.repo>
			</properties>
		</profile>


		<profile>
			<id>docker</id>

			<properties>
				<!-- docker镜像前缀 -->
				<docker.image.prefix>youlu</docker.image.prefix>
				<!-- HTTP方式健康检查URL，注意修改为自己系统实际的健康检查URL，host使用127.0.0.1 -->
				<app.probe.http.path>http://127.0.0.1:8180/revenuesystem/api/rs/system/health</app.probe.http.path>
				<!-- 应用打包后的jar或war包所在目录，相对位置（相对于dockerfile） -->
				<bin.file.path>target</bin.file.path>
				<!-- 应用打包后jar包或war包的名字 -->
				<bin.file.name>revenuesystem.jar</bin.file.name>
				<!-- 应用ID，注意，要和Apollo中一致 -->
				<app.id>revenuesystem</app.id>
				<!-- 应用配置所在tomcat目录，对TOMCAT部署有用 -->
				<app.prop.file.dir>lib</app.prop.file.dir>
				<!-- 应用配置名称 -->
				<app.prop.file.name>${app.id}.properties</app.prop.file.name>
				<!-- 应用部署方式，枚举类型，TOMCAT和STANDARD，如果是在tomcat中部署启动的就选tomcat，如果是独立启动的就选STANDARD -->
				<app.deploymentmode>STANDARD</app.deploymentmode>
				<!-- 应用工作目录，没有特殊需求无需更改 -->
				<app.basedir>/root/app/work</app.basedir>
				<!-- 应用资源，没有特殊需求无需更改 -->
				<app.resource>/root/app/resource/${bin.file.name}</app.resource>
				<!-- tag标签 -->
				<docker.tag>${project.version}</docker.tag>
			</properties>

			<build>
				<plugins>
					<plugin>
						<groupId>com.spotify</groupId>
						<artifactId>dockerfile-maven-plugin</artifactId>
						<version>1.4.13</version>
						<executions>
							<execution>
								<id>default</id>
								<goals>
									<goal>build</goal>
									<goal>push</goal>
								</goals>
							</execution>
						</executions>
						<configuration>
							<!-- 仓库 -->
							<repository>${docker.repo}/${docker.image.prefix}/${project.artifactId}</repository>
							<!-- docker image的tag，相当于版本号 -->
							<tag>${docker.tag}</tag>
							<!-- 使用maven全局配置中的用户名密码 -->
							<useMavenSettingsForAuth>true</useMavenSettingsForAuth>
							<buildArgs>
								<BIN_FILE_PATH>${bin.file.path}</BIN_FILE_PATH>
								<BIN_FILE_NAME>${bin.file.name}</BIN_FILE_NAME>
								<DOCKER_BUILD_APP_ID>${app.id}</DOCKER_BUILD_APP_ID>
								<DOCKER_BUILD_APP_PROP_FILE_DIR>${app.prop.file.dir}</DOCKER_BUILD_APP_PROP_FILE_DIR>
								<DOCKER_BUILD_APP_PROP_FILE_NAME>${app.prop.file.name}</DOCKER_BUILD_APP_PROP_FILE_NAME>
								<DOCKER_BUILD_DEPLOYMENT_MODE>${app.deploymentmode}</DOCKER_BUILD_DEPLOYMENT_MODE>
								<DOCKER_BUILD_BASE_DIR>${app.basedir}</DOCKER_BUILD_BASE_DIR>
								<DOCKER_BUILD_APP_RESOURCE>${app.resource}</DOCKER_BUILD_APP_RESOURCE>
								<HTTP_PROBE_PATH>${app.probe.http.path}</HTTP_PROBE_PATH>
							</buildArgs>
						</configuration>
					</plugin>
				</plugins>
			</build>
		</profile>
	</profiles>

</project>