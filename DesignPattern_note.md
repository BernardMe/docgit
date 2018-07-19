
## 设计模式

### 单例模式

- 私有静态变量
- 私有化构造器
- 获取本类实例唯一全局访问点

### 简单工厂模式



### 观察者模式与监听模式区别

一，类的四大基本关系： 

a.关联关系：如A类调用B类。 

b.继承关系：如A类是B类的父类。 

c.聚合关系：如装橘子的箱子，箱子是否存在与里面装没装橘子没有任何关系，也就是说橘子不会影响箱子的存在。 

d.组合关系：如一个小组，小组是否存在与小组中是否有组员是息息相关的，如果没有组员，小组就不存在了。

监听器模式：
事件源经过事件的封装传给监听器，当事件源触发事件后，监听器接受到事件对象可以回调事件的方法

观察者模式：
观察者(Observer)相当于事件监听者，被观察者(Observer)相当于事件源和事件，执行逻辑时通知observer即可触发observer的update，同时可传被观察者和参数


###　监听模式
当事件源对象上发生操作时，将会调用事件监听器的一个方法，并在调用该方法时把事件对象传递过去

`事件源`
具体的事件源，注册特定的监听，才可以对事件进行响应

`事件对象`
封装了事件源对象以及与事件相关的信息，是在事件源和事件监听器之间传递信息的角色

`事件监听器`
监听事件，并进行事件处理或者转发，必须注册在事件源上


### 代理模式

#### 代理模式(静态代理)的通俗理解

首先不谈模式，举一个例子：
有一队很美丽的妹子，她们都是训练有素的迎宾小姐。平时忙于训练再加上人脉与广告投入不多，生意并不好。于是她们的老大提议去找一个礼仪公司合作，请他们把迎宾的活儿包给她们来做。恰好在某个公司有个接待外宾的活动，该活动交给一个这个知名的礼仪公司负责，礼仪公司就通知了迎宾小姐。在外宾下车时就要乐队奏乐，走到公司门口时，迎宾小姐需要致以问候。现在来模拟一下这个情景。

```java
//相当于迎宾小姐(委托类)
class HelloGril{
	public void sayHello(){
		System.out.print("Hello");
	}
}

//相当于这个礼仪公司(代理类)
public class StaticProxy{
	//持有了迎宾小姐的资源
	private HelloGril helloGirl;

	public StaticProxy(){
		helloGirl = new HelloGril();
	}
	//迎宾活动
	public void doActivi(){
		//自己的乐队奏乐
		System.out.print("do sth...");
		//迎宾小姐欢迎
		helloGirl.sayHello();

	}
}
```
可是事情进展的并不顺利,突然听说这些个外宾都会中文，而且其中的重量级人物很喜欢中国传统文化。于是该公司要求礼仪公司立即换掉迎宾小姐，请一队着汉服而且普通话好的来。幸好该队迎宾小姐都是狠角色，各种场面都能应付。

于是我们做如下修改：
```java
//相当于迎宾小姐新阵容
public class AnotherHelloGril {
	public void sayhello(){
		System.out.println("您好！");
	}
}

//相当于这个礼仪公司(代理类)
public class StaticProxy{
	//持有了迎宾小姐的资源
	private AnotherHelloGril anotherHelloGril;

	public StaticProxy(){
		anotherHelloGril = new AnotherHelloGril();
	}
	//迎宾活动
	public void doActivi(){
		//自己的乐队奏乐
		System.out.print("do sth...");
		//迎宾小姐欢迎
		anotherHelloGril.sayHello();

	}
}
```

迎宾队伍的老大又想，这样太麻烦了，每次换来换去的折腾不起，倒不如我们再召些人马，加强多元化的训练，使自己的团队能应付各种场面，然后根据需求迅速做出响应。

```java
//专业迎宾团队
public interface IHelloGril {
	//规定了做什么
	public void sayhello();
}
//第一小队
public class HelloGrilImpl implements IHelloGril{
	//照着规章去做     说英语
	public void sayhello(){
		System.out.println("Hello!");
	}
}
 
//第二小队
public class HelloGrilImpl2 implements IHelloGril {
	//同样是致欢迎   用标准普通话
	@Override
	public void sayhello() {
		System.out.println("您好 ！");
	}
}
```

修改代理类：

```java
//相当于这个礼仪公司
public class StaticProxy{
	//持有了迎宾团队的资源
	private IHelloGril hello ;
  
	public StaticProxy() {
	//招呼迎宾团队准备上场,具体派哪对视情况而定
		girl = new HelloGrilImpl();
        //hello = new HelloWorldImpl2();
	}
 
	//迎宾活动
	public void sayhello() {
		//自己的乐队奏乐
		System.out.println("do  something....");
		//迎宾小姐欢迎
		girl.sayhello();
	}
	
	public static void main(String[] args) {
		//该公司并不知道有迎宾团队的存在   它只和代理(礼仪公司)接触
		StaticProxy staticProxy = new StaticProxy();
		staticProxy.sayhello();
	}	
}
```
修改后的代码可以说是一个静态代理了，设计模式提倡针对接口编程,而不是针对实现编程,这样可以灵活多变。最开始的代码可以说是一种代理，但不是一种模式，模式讲究的是良好的设计，如果进一步强调通用性和可扩展性，那就不得不提到JDK和cglib的动态代理。

 从上面来总结一下静态代理：

有些类由于自己功能有限，需要其他的类做一些工作来辅助完成某些功能，虽然这些辅助工作是必须的，但是委托类却不需要自己去做，一是他没有资源，二是它应该注重自己擅长的事情。这样一些代理类应运而生，它专门做一些事前和善后的处理，让委托类专注于自己的事情。
在生活中有很多这样的例子，就像上面的迎宾团队，它的团队训练有素，能力很强，但是它却没有能力去接一些大活儿，这样他可以去找礼仪公司，两者签订合作协议，让礼仪公司出去接活儿，迎宾部分到时候包给该团队去做，这样各得其所。还有就是常常在幕后为明星忙碌的经纪人，他们就是活生生的代理。

！[proxy](./439px-Proxy_pattern_diagram.svg.png)
Subject类，定义了RealSubject和Proxy的共用接口，这样就在任何使用RealSubject的地方都可以使用proxy。





