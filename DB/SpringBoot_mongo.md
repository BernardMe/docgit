

集成


  maven依赖
	在pom文件引入spring-boot-starter-data-mongodb依赖：
	<dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-data-mongodb</artifactId>
    </dependency>


  零配置(使用默认配置)
	主要配置数据库连接、MongoTemplate。我们可以使用以“spring.data.mongodb”为前缀的属性来配置MongoDB相关的信息。Spring Boot为我们提供了一些默认属性，如默认MongoDB的端口为27017、默认服务器为localhost、默认数据库为test。Spring Boot的主要配置如下：

	# SpringBoot Properties常用应用属性配置列表
	# MONGODB (MongoProperties)
	spring.data.mongodb.authentication-database= # Authentication database name.
	spring.data.mongodb.database=test # Database name.
	spring.data.mongodb.field-naming-strategy= # Fully qualified name of the FieldNamingStrategy to use.
	spring.data.mongodb.grid-fs-database= # GridFS database name.
	spring.data.mongodb.host=localhost # Mongo server host. Cannot be set with uri.
	spring.data.mongodb.password= # Login password of the mongo server. Cannot be set with uri.
	spring.data.mongodb.port=27017 # Mongo server port. Cannot be set with uri.
	spring.data.mongodb.repositories.enabled=true # Enable Mongo repositories.
	spring.data.mongodb.uri=mongodb://localhost/test # Mongo database URI. Cannot be set with host, port and credentials.
	spring.data.mongodb.username= # Login user of the mongo server. Cannot be set with uri.

  
  手动覆盖默认配置
	system.properties:
	# 手动配置
	# spring-data-mongodb
	spring.data.mongodb.database=blacktech
	spring.data.mongodb.field-naming-strategy=
	spring.data.mongodb.grid-fs-database=
	spring.data.mongodb.host=127.0.0.1
	spring.data.mongodb.password=blacktech
	spring.data.mongodb.port=27017
	spring.data.mongodb.repositories.enabled=true
	spring.data.mongodb.uri=mongodb://blacktech:blacktech@localhost:27017/blacktech
	
  
  Model
	public class Customer {
 
	  @Id
	  public String id;
	 
	  public String firstName;
	  public String lastName;
	 
	  public Customer() {}
	 
	  public Customer(String firstName, String lastName) {
		this.firstName = firstName;
		this.lastName = lastName;
	  }
	 
	  @Override
	  public String toString() {
		return String.format(
			"Customer[id=%s, firstName='%s', lastName='%s']",
			id, firstName, lastName);
	  }
	 
	}

  Repository的支持
	类似于Spring Data JPA，Spring Data MongoDB也提供了Repository的支持，使用方式和Spring Data JPA一致，定义如下：

	@Repository
	public interface CustomerRepository extends MongoRepository<Customer, String> {

	}
	

  @EnableMongoRepositories注解
	在SpringBoot启动类上加注解
	为我们开启了对Repository的支持，即自动为我们配置了@EnableMongoRepositories。所以我们在Spring Boot下使用MongoDB只需引入spring-boot-starter-data-mongodb依赖即可，无须任何配置


	
查询

	
索引

集群	
	
	
	
	
	
	
	