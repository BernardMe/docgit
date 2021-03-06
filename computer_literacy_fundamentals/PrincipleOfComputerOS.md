



# 基础概念

## 散列函数(Hash Function)
散列函数（或散列算法，又称哈希函数，英语：Hash Function）是一种从任何一种数据中创建小的数字“指纹”的方法。散列函数把消息或数据压缩成摘要，使得数据量变小，将数据的格式固定下来。该函数将数据打乱混合，重新创建一个叫做散列值（hash values，hash codes，hash sums，或hashes）的指纹。散列值通常用一个短的随机字母和数字组成的字符串来代表。好的散列函数在输入域中很少出现散列冲突。在散列表和数据处理中，不抑制冲突来区别数据，会使得数据库记录更难找到

![Hash_table](Hash_table_4_1_1_0_0_1_0_LL.svg.png)

## 相对路径和绝对路径
`绝对路径表示在系统任何位置cd可达，相对路径表示在当前目录cd可达`

### 散列函数的性质
所有散列函数都有如下一个基本特性：如果两个散列值是不相同的（根据同一函数），那么这两个散列值的原始输入也是不相同的。这个特性是散列函数具有确定性的结果，具有这种性质的散列函数称为单向散列函数。但另一方面，散列函数的输入和输出不是唯一对应关系的，如果两个散列值相同，两个输入值很可能是相同的，但也可能不同，这种情况称为“散列碰撞（collision）”，这通常是两个不同长度的输入值，刻意计算出相同的输出值。

典型的散列函数都有非常大的定义域，比如SHA-2最高接受(264-1)/8长度的字节字符串。同时散列函数一定有着有限的值域，比如固定长度的比特串。在某些情况下，散列函数可以设计成具有相同大小的定义域和值域间的单射。散列函数必须具有不可逆性。


## 进程

进程一般由程序、数据集合和进程控制块三部分组成。

程序用于描述进程要完成的功能，是控制进程执行的指令集；
数据集合是程序在执行时所需要的数据和工作区；
程序控制块(Program Control Block, 简称PCB)，包含进程的描述信息和控制信息，是进程存在的唯一标识。

### 进程具有的特征
动态性
并发性
独立性
结构性


### 进程地址空间

我们一般都知道，每个程序都能看到一片完整连续的地址空间，`这些空间并没有直接关联到物理内存，而是操作系统提供了内存的一种抽象概念`，使得每个进程都有一个连续完整的地址空间，在程序的运行过程，再完成虚拟地址到物理地址的转换。

通常情况下，进程的内存地址空间是独立的。



## 线程

在早期的操作系统中并没有线程的概念，进程是拥有资源和独立运行的最小单位，也是程序执行的最小单位。
任务调度采用的时间片轮转的抢占式调度方式，而进程是任务调度的最小单位，每个进程有各自独立的一块内存，使得各个进程之间内存地址相对隔离。

后来随之计算机的发展，对CPU的要求越来越高，进程之间的切换开销较大，已经无法满足越来越复杂的程序的要求了。于是就发明了线程，线程是程序执行中一个单一的顺序控制流程，是程序执行流的最小单位，是处理器调度和分派的基本单位。一个进程可以有一个或多个线程，各个线程之间共享程序的内存空间(也就是所在进程的内存空间)。一个标准的线程由线程ID，当前指令指针(PC)，寄存器和堆栈组成。而进程由内存空间(代码，数据，进程空间，打开的文件)和一个或多个线程组成。

## 进程与线程的区别

1 线程是程序执行的最小单位，而进程是操作系统分配资源的最小单位；
2 一个进程有一个或多个线程组成，线程是一个进程中代码的不同执行路径；
3 进程之间相互独立，但同一进程下的各个线程之间共享程序的内存空间(包括代码段，数据集，堆等)及一些进程级的资源(如打开文件和信号)，某进程内的线程在其他进程不可见；




