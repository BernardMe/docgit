

# 预备知识

## 概念

### 缓存能解决的问题
性能 
==> 将相应数据村吃起来以避免数据的重复创建，处理和传输，可有效提高性能。
比如将不改变的数据缓存起来，例如国家列表等，这样能明显提高web程序的反应速度；
稳定性 
==> 同一个应用中，对同一数据，逻辑功能和用户界面的多次请求时经常发生的。当用户基数很大时，如果每次请求都进行处理，消耗的资源是很大的浪费，也同时造成系统的不稳定。例如，web应用中，对一些静态页面的呈现内容进行缓存能有效的节省资源，提高稳定性。而缓存数据也能降低对数据库的访问次数，降低数据库的负担和提高数据库的服务能力；
可用性 
==> 有时，提供数据信息的服务可能会意外停止，如果使用了缓存技术，可以在一定时间内扔正常提供对最终用户的支持，提高了系统的可用性。

### 缓存特征

#### 命中率
命中率=返回正确结果数/请求缓存次数，命中率问题是缓存中的一个非常重要的问题，它是衡量缓存有效性的重要指标。命中率越高，表明缓存的使用率越高。
 
#### 最大元素(或最大空间)
缓存中可以存放的最大元素的数量，一旦缓存中元素数量超过这个值（或者缓存数据所占空间超过其最大支持空间），那么将会触发缓存启动清空策略根据不同的场景合理的设置最大元素值往往可以一定程度上提高缓存的命中率，从而更有效的时候缓存。

#### 清空策略
如上描述，缓存的存储空间有限制，当缓存空间被用满时，如何保证在稳定服务的同时有效提升命中率？这就由缓存清空策略来处理，设计适合自身数据特征的清空策略能有效提升命中率。常见的一般策略有：
FIFO(first in first out)
LFU(less frequently used)
LRU(least recently used)

### 缓存分类和应用场景
在目前的应用服务框架中，比较常见的，时根据缓存与应用的藕合度，分为local cache（本地缓存）和remote cache（分布式缓存）：


### 什么是进程内缓存
顾名思义，进程内缓存是与应用程序在相同地址空间的缓存。
Google Guava是一个提供了简单进程内缓存API的很好的例子。
另一方面，分布式缓存是应用程序的外部扩展，通常部署在多个节点上，共同构成一个大的逻辑缓存。
Memcached是一个流行的分布式缓存。Ehcache则是一个通过配置可以以任一种方式使用的缓存产品。


### 一致性
进程内缓存
当使用进程内缓存时，缓存元素是特定应用程序实例本地的。然而，许多中到大型应用通常会做负载均衡，从而不存在一个作为整体的独立应用。在这种情况下，很可能会构建出一个有多少应用实例就有多少缓存的解决方案，每个缓存都有各自的状态，这就导致了不一致性。随着缓存元素的过期或被逐出，所有缓存实例间可能达到最终一致性。

分布式缓存
分布式缓存，虽然部署在由多个节点构成的集群上，会提供一个单一缓存的逻辑视图（以及状态）。多数情况下，分布式缓存中的对象将会存在于集群中的单个节点。通过哈希算法，缓存引擎总是可以判断出某个键值对位于哪个特定节点。由于整个集群总是会有一个特定状态，所以从来不会存在不一致的情况。


### 开销
进程内缓存
揭开进程内缓存的奥秘 一文中提到进程内缓存可能会影响垃圾回收进而影响系统性能。而这将会由缓存大小以及对象逐出和过期的频率决定。

分布式缓存
分布式缓存有两大主要开销会导致其慢于进程内缓存(但优于无缓存方案)：
网络延时
对象序列化

备注
正如之前所提到的，如果你试图寻求一个多节点部署情况下的强一致性缓存解决方案，采用分布式缓存。


### 可靠性
进程内缓存
进程内缓存使用与应用程序相同的堆空间，因此必须非常小心地决定缓存所能使用的内存大小上限。如果应用程序用光了内存，想要试图恢复并不容易。

分布式缓存
分布式缓存作为多个节点的独立进程运行，因此单点故障并不会导致缓存失效。丢失的缓存元素将会在下一次缓存未命中时进入存活的节点。分布式缓存情况下，缓存整体失效的最坏后果是降低系统性能，而不是导致系统整体故障。

备注
进程内缓存适用于较小且频率可预见的访问场景，尤其适用于不变对象。
对于较大且不可预见的规模的访问，最好采用分布式缓存。


## 实现原理

### Java中缓存的原理

外存：
也就是我们经常说的（CDEF盘的大小）外储存器是指除计算机内存及CPU缓存以外的储存器，此类储存器一般断电后仍然能保存数据。常见的外存储器有硬盘、软盘、光盘、U盘等，一般的软件都是安装在外存中

内存：
内存是计算机中重要的部件之一，它是与CPU进行沟通的桥梁。计算机中所有程序的运行都是在内存中进行的，因此内存的性能对计算机的影响非常大。内存(Memory)也被称为内存储器，其作用是用于暂时存放CPU中的运算数据，以及与硬盘等外部存储器交换的数据。只要计算机在运行中，CPU就会把需要运算的数据调到内存中进行运算，当运算完成后CPU再将结果传送出来，内存的运行也决定了计算机的稳定运行，此类储存器一般断电后数据就会被清空

高速缓存：
　　高速缓存是用来协调CPU与主存之间存取速度的差异而设置的。一般情况下，CPU的工作速度高，但内存的工作速度相对较低，为了解决这个问题，通常使用高速缓存，高速缓存的存取速度介于CPU和主存之间。系统将一些CPU在近几个时间段经常访问的内容存入高速缓存，当CPU需要使用数据时，先在高速缓存中找，如果找到，就不必访问内存了，找不到时，再找内存，这样就在一定程度上缓解了由于主存速度低造成的CPU“停工待料”的情况


之前一直很不理解这个缓存那个缓存，其实缓存就是把一些外存上的数据保存到内存上而已，怎么保存到内存上呢，我们运行的所有程序，里面的变量值都是放在内存上的，所以说如果要想使一个值放到内存上，实质就是在获得这个变量之后，`用一个生存期较长的变量存放你想存放的值`，在java中一些缓存一般都是通过map集合来做的。　

在Java中经常用到缓存，在SSh框架中也会用到一级缓存和二级缓存，到底缓存是怎么实现的呢？

简单讲就是，如果某些资源或者数据会被频繁的使用，而这些资源或数据存储在系统外部，比如数据库、硬盘文件等，那么每次操作这些数据的时候都从数据库或者硬盘上去获取，速度会很慢，会造成性能问题。

一个简单的解决方法就是：把这些数据缓存到内存里面，每次操作的时候，先到内存里面找，看有没有这些数据，如果有，那么就直接使用，如果没有那么就获取它，并设置到缓存中，下一次访问的时候就可以直接从内存中获取了。从而节省大量的时间，当然，缓存是一种典型的空间换时间的方案。

在Java中最常见的一种实现缓存的方式就是使用Map, 基本的步骤是：
+ 先到缓存里面查找，看看是否存在需要使用的数据
+　如果没有找到，那么就创建一个满足要求的数据，然后把这个数据设置回到缓存中，以备下次使用
+ 如果找到了相应的数据，或者是创建了相应的数据，那就直接使用这个数据。

```java
/**
* Java中缓存的基本实现示例
*/
public class JavaCache {
    /**
    * 缓存数据的容器，定义成Map是方便访问，直接根据Key就可以获取Value了
    * key选用String是为了简单，方便演示
    */
    private Map<String,Object> map = new HashMap<String,Object>();
    /**
    * 从缓存中获取值
    * @param key 设置时候的key值
    * @return key对应的Value值
    */
    public Object getValue(String key){
        //先从缓存里面取值
        Object obj = map.get(key);
        //判断缓存里面是否有值
        if(obj == null){
            //如果没有，那么就去获取相应的数据，比如读取数据库或者文件
            //这里只是演示，所以直接写个假的值
            obj = key+",value";
            //把获取的值设置回到缓存里面
            map.put(key, obj);
        }
        //如果有值了，就直接返回使用
        return obj;
    }
}
```
这里只是缓存的基本实现，还有很多功能都没有考虑，比如缓存的清除，缓存的同步等等。当然，Java的缓存还有很多实现方式，也是非常复杂的，现在有很多专业的缓存框架，更多缓存的知识，这里就不再去讨论了。

下面用单例模式实现缓存：
```java
/**
* 使用缓存来模拟实现单例
*/
public class Singleton {
    /**
    * 定义一个缺省的key值，用来标识在缓存中的存放
    */
    private final static String DEFAULT_KEY = "One";
    /**
    * 缓存实例的容器
    */
    private static Map<String,Singleton> map =
    new HashMap<String,Singleton>();
    /**
    * 私有化构造方法
    */
    private Singleton(){
    //
    }
    public static Singleton getInstance(){
        //先从缓存中获取
        Singleton instance = (Singleton)map.get(DEFAULT_KEY);
        //如果没有，就新建一个，然后设置回缓存中
        if(instance==null){
            instance = new Singleton();
            map.put(DEFAULT_KEY, instance);
        }
        //如果有就直接使用
        return instance;
    }
}
```













