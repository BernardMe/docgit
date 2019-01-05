

### JNA介绍

JNA(Java Native Access)：建立在JNI之上的Java开源框架，SUN主导开发，用来调用C、C++代码，尤其是底层库文件（windows中叫dll文件，linux下是so【shared object】文件）。

 
JNI是Java调用原生函数的唯一机制，JNA就是建立在JNI之上，JNA简化了Java调用原生函数的过程。JNA提供了一个动态的C语言编写的转发器（实际上也是一个动态链接库，在Linux-i386中文件名是：libjnidispatch.so）可以自动实现Java与C之间的数据类型映射。从性能上会比JNI技术调用动态链接库要低。


JNA（Java Native Access ）提供一组Java工具类用于在运行期间动态访问系统本地库（native library：如Window的dll）而不需要编写任何Native/JNI代码。开发人员只要在一个java接口中描述目标native library的函数与结构，JNA将自动实现Java接口到native function的映射。

JNA可以让你像调用一般java方法一样直接调用本地方法。就和直接执行本地方法差不多，而且调用本地方法还不用额外的其他处理或者配置什么的，也不需要多余的引用或者编码，使用很方便。


[整体思路]
Java版接口---->通过JNA调用模板层工具方法映射类JNA---->调用C版接口---->调用C动态库

C版接口
com/hslt/havon/template/jna/hwcfsdk.h

通过JNA调用模板层工具方法映射类
com.hslt.havon.template.jna.TemplateLibMapping

Java版接口
com.hslt.havon.template.ITemplateDeal
