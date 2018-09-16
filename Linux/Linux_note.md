

## 应该如何提问

### 先要尝试自己解决
- 帮助文档
- 示例

### 提问的智慧
- 问题详尽
- 贴图

### Linux与Windows的不同
- (字符界面)Linux严格区分大小写
- Linux中所有内容以文件形式保存，包括硬件(一切内容皆文件)
- Linux不靠扩展名区分文件类型，靠权限来区分
	+ 但是有一些约定俗成的扩展名
	+ 压缩包 *.gz  *.tar.gz
	+ 二进制软件包 *.rpm
	+ 网页文件 *.html .php
	+ 脚本文件 *.sh
- Windows下的程序不能直接在Linux中安装和运行
	+ 好：Win的木马和病毒不能执行
	+ 坏：针对Win的软件所有程序要重新开放



## VMware主要特点
- 不需要分区或重新开机就能在同一台PC上使用两种以上的操作系统
- 本机系统可以与虚拟机系统网络通信
- 可以设定并且随时修改虚拟机操作系统的硬件环境 

### 虚拟机网络设置
桥接  虚拟机可以连接局域网，和其他网络设备通信
NAT 虚拟机只能和实体机通信，再连接局域网
Host only 虚拟机只能和实体机通信，不能连接局域网



## 系统分区

### 分区类型
>把大硬盘分为小的逻辑分区

- 主分区：最多只能有4个(硬盘结构决定的)
- 扩展分区
	+ 最多只能有1个
	+ 主分区加扩展分区最多有4个
	+ 不能写入数据，只能包含逻辑分区
- 逻辑分区

### 格式化
>为了写入文件系统，在分区中划出一片用于存放文件分配表，目录表等用于文件管理的磁盘空间。

为了查找/读取文件更快捷，将空间分成数据块(block, 默认4KB)

### Linux格式化
- 把整个分区分成等大小的数据块
- 在分区列表中建立一个二维表格(i节点，权限，修改时间等)

### 硬件设备文件名
`/`代表根目录 `/dev`专门用来存放硬件设备文件名
硬件 | 设备文件名
- | -
IDE硬盘 | /dev/hd[a-d]

### 分区设备文件名
>给每个分区define设备文件名

- 设备文件名
	+ /dev/hda1(IDE硬盘接口) `a`代表第一块硬盘 `1`代表1分区
	+ /dev/sda1(SCSI硬盘接口，SATA硬盘接口)
- 分区表示
	+ 即使只有一个主分区，扩展分区中的多个逻辑分区一定从分区号5开始

### 挂载(分配的'盘符'称为'挂载点')
>给每个分区分配挂载点，把'挂载点'和分区连接起来

挂载是过程，就是给分区分配'盘符'的过程, 用目录作为'盘符'
- 必须分区
	+ /(根分区)
	+ swap分区(交换分区，内存2倍，4G内存以上和内存一样大小即可)
- 推荐分区
	+ /boot(启动分区，200MB)



## shell和终端仿真器

### 什么是shell
一说到命令行，我们真正指的是shell。shell就是一个程序，它接受从键盘输入的命令，然后把命令传递给操作系统去执行。几乎所有的Linux发行版都提供一个名为bash的来自GNU项目的shell程序。“bash”就是“Bourne Again SHell”的首字母缩写，所指的是这样一个事实，bash是最初Unix上由Steve Bourne写成shell程序sh的增强版。

### 终端仿真器
当使用图形用户界面时，我们需要另一个和shell交互的叫做终端仿真器的程序。如果我们浏览一下桌面菜单，可能会找到一个。虽然在菜单里它可能都 被简单地称为 “terminal”，但是 KDE 用的是 konsole , 而 GNOME 则使用 gnome-terminal。 还有其他一些终端仿真器可供 Linux 使用，但基本上，它们都完成同样的事情， 让我们能访问 shell。也许，你可能会因为附加的一系列花俏功能而喜欢上某个终端。

第一次按键
启动终端仿真器！一旦它运行起来，我们应该看到一行这样的文字
`[root@localhost ~]#`
这叫做shell提示符，无论何时当shell准备好了去接受输入时，它就会出现。然而， 它可能会以各种各样的面孔显示，这则取决于不同的 Linux 发行版， 它通常包括你的用户名@主机名，紧接着当前工作目录（稍后会有更多介绍）和一个美元符号。
如果提示符的最后一个字符是“#”，而不是“$”，那么这个终端会话就有超级用户权限。这意味着，我们或者是以root用户的身份登录，或者是我们选择的终端仿真器提供超级用户（管理员）权限。

### 关于鼠标和光标
虽然，shell是和键盘打交道的，但你也可以在终端仿真器里使用鼠标。X 窗口系统 （使 GUI 工作的底层引擎）内建了一种机制，支持快速拷贝和粘贴技巧。 如果你按下鼠标左键，沿着文本拖动鼠标（或者双击一个单词）高亮了一些文本， 那么这些高亮的文本就被拷贝到了一个由 X 管理的缓冲区里面。然后按下鼠标中键， 这些文本就被粘贴到光标所在的位置。试试看。

注意：不要在一个终端窗口里使用Ctrl-c和Ctrl-v快捷键来执行拷贝和粘贴操作。它们不起作用。对于shell来说，这两个控制代码有着不同的含义，它们在早于Microsoft Windows
（定义复制粘贴的含义）许多年之前就赋予了不同的意义。

你的图形桌面环境（像 KDE 或 GNOME），努力想和 Windows 一样，可能会把它的聚焦策略 设置成“单击聚焦”。这意味着，为了让窗口聚焦（变成活动窗口）你需要单击它。 这与“聚焦跟随着鼠标”的传统 X 行为不同，传统 X 行为是指只要把鼠标移动到一个窗口的上方。 它能接受输入， 但是直到你单击窗口之前它都不会成为前端窗口。 设置聚焦策略为“聚焦跟随着鼠标”，可以使拷贝和粘贴更方便易用。尝试一下。 我想如果你试了一下你会喜欢上它的。你能在窗口管理器的配置程序中找到这个设置。

结束终端会话
我们可以通过关闭终端仿真器窗口，或者是在shell提示符下输入exit命令来终止一个终端会话：
`[me@linuxbox ~]$ exit`

### 幕后控制台
即使终端仿真器没有运行，在后台仍然有几个终端会话运行着。它们叫做虚拟终端（或者是虚拟控制台）。在大多数Linux发行版中，这些终端会话都可以通过按下Ctrl-Alt-F1到Ctrl-Alt-F6访问。当一个会话被访问的时候，它会显示登录提示框，我们需要输入用户名和密码。要从一个虚拟控制台转换到另一个，按下Alt和F1-F6（中的一个）。返回图形桌面，按下Alt-F7。

### 家目录
- 超级管理员家目录 /root (/下的一级目录)
- 普通用户家目录 /home/user1/ (/home/下的二级目录)
`pwd`(Print Working Directory)显示当前目录







## Linux下创建shell脚本文件

1 touch 位置/文件名
2.编写脚本内容
（注：第一行一定要写这句：#!/bin/sh  一般是用这个（Bourne Again Shell））
3.chmod o+x /etc/init.d/redis.sh(变为执行文件)  


## Linux权限rwx转数字的一个小tips

从最简单的说起
-代表无权限，用数字表示是 0
r代表读权限，用数字表示是4
w代表写权限，用数字表示是2
x代表执行权限,用数字表示是1

老师讲的转换方式
以前在兄弟连培训的时候，李超老师讲过，一个方法

就是把要给的权限先转换成数字，然后加起来

比如777权限，7=1+2+4，其中1、2、4分别代表执行、读、写。

三个7中，第一个7代表文件所属用户对该文件的权限为7(所有权限)
第二个7代表文件所属用户组对该文件的权限为7
第三个7代表其他用户组对该文件的权限为7
（ps:也就是说任何一个人对该文件都有读写执行权限，所以说嘛～不要随便设置777权限）

自己get到的一个转换方式
假设我们要给一个文件如下权限（所属用户拥有rwx，同用户组和其他用户拥有读和执行）：

-rwxr-xr-x

第一个-代表这是一个文件，如果是目录则会显示d

我们把后面权限的部分拿出来，用二进制来表示，如果有权限用1表示，反之为0

那么这个文件权限转换成了

111 101 101

然后把每个三位数转换成10进制，分别为：

7 5 5

看到755 是不是就明白啦～～

## Windows中虚拟机Linux传输文件的两个简单的方法

### mount挂载
首先创建被挂载的目录：
`$ mkdir /mnt/music`

将共享文件夹挂载到windows文件夹：
`$ sudo mount -t cifs -o username=share,password=share //192.168.66.198/share /mnt/music`

### 使用samba连接
samba就是让windows和unix系列os之间的文件可以互相访问的软件。使用samba访问windows的共享文件夹，需要安装smbclient。
`$ sudo apt-get install smbclient`

安装好后，就可以访问共享的文件了。

```bash
$ smbclient --user=share //192.168.66.198/share
Enter share password: （输入密码回车）
smb: \>
```

此时进入了smb的命令操作空间，可以使用help来查看命令的使用。



## CentOS

### linux各文件夹的作用
linux下的文件结构，看看每个文件夹都是干吗用的
/bin 二进制可执行命令 
/dev 设备特殊文件 
/etc 系统管理和配置文件 
/etc/rc.d 启动的配置文件和脚本 
/home 用户主目录的基点，比如用户user的主目录就是/home/user，可以用~user表示 
/lib 标准程序设计库，又叫动态链接共享库，作用类似windows里的.dll文件 
/media/	可移除媒体(如CD-ROM)的挂载点(在FHS-2.3中出现)
/mnt 临时挂载的文件系统。 
/sbin 系统管理命令，这里存放的是系统管理员使用的管理程序 
/tmp 公用的临时文件存储点 
/root 系统管理员的主目录（呵呵，特权阶级） 
/lost+found 这个目录平时是空的，系统非正常关机而留下“无家可归”的文件（windows下叫什么.chk）就在这里 
/proc 虚拟的目录，是系统内存的映射。可直接访问这个目录来获取系统信息。 
/root/ 超级用户的家目录
/usr 最庞大的目录，要用到的应用程序和文件几乎都在这个目录。其中包含： 
- /usr/bin 众多的应用程序 
- /usr/include linux下开发和编译应用程序所需要的头文件 
- /usr/lib 常用的动态链接库和软件包的配置文件 
- /usr/local/bin 本地增加的命令 
- /usr/local/lib 本地增加的库
- /usr/sbin 超级用户的一些管理程序 
- /usr/doc linux文档 
- /usr/man 帮助文档 
- /usr/src 源代码，linux内核的源代码就放在/usr/src/linux里 
- /usr/x11r6 存放x window的目录 
/var 某些大文件的溢出区，比方说各种服务的日志文件 
- /var/cache 应用程序缓存数据。这些数据是在本地生成的一个耗时的I/O或计算结果。
- /var/lib 状态信息。由程序在运行时维护的持久性数据。
- /var/lock 锁文件，一类跟踪当前使用中资源的文件
- /var/log 日志文件，包含大量日志文件
- /var/mail 用户的电子邮箱。
- /var/run 自最后一次启动以来运行中的系统的信息，
- /var/spool 等待处理的任务的脱机文件，
- /var/tmp 在系统重启过程中可以保留的临时文件




## Linux常用命令

命令 [选项] [参数]

### clear
控制台下清屏命令

### less
less [参数] 文件..
使用less可以随意浏览文件
-N 显式每行的行号

### nl
nl [-bnw] 文件
小文本文件的查看

### vim
vim 文件

### ls
ls [选项] [文件或目录]
选项:
-a 显示所有文件，包括隐藏文件 .开头是隐藏文件
-l 显示详细信息		
- `-rw-r--r--`
	+ `-`文件类型(-文件 d目录 l软链接文件 b块设备文件 c字符设备文件 s套接字文件 p管道文件)
	+ `rw-`u所有者 `r--`g所属组 `r--`o其他人
	+ r读 w写 x执行
-d 查看目录属性
-h 人性化显示文件大小
-i 显示inode

### 文件名颜色的含义

1）默认色代表普通文件。例：install.log

2）绿色代表可执行文件。例：rc.news

3）红色代表tar包 文件。 例：vim-7.1.tar.bz2

4）蓝色代表目录文件。  例：aa

5）水红代表图象文件。  例：Sunset.jpg

6）青色代表链接文件。  例：rc4.d     （此类文件相当于快捷方式）

7）黄色代表设备文件。  例：fd0


### cd切换所在目录
cd [目录]
cd ~ 进入当前用户的家目录
cd   进入当前用户的家目录
cd - 进入上次目录
cd .. 进入上一级目录
cd . 进入当前目录

#### 相对路径
参照当前所在目录，进行查找
如：`cd ../usr/local/src/`

#### 绝对路径
从根目录开始指定，一级一级递归查找。在任何目录下，都能进入指定位置
如：`cd /etc/`


### mkdir
mkdir建立目录
mkdir -p [目录名]
-p 递归创建

mkdir 命令用来创建指定的名称的目录，要求创建目录的用户在当前目录中具有写权限，并且指定的目录名不能是当前目录中已有的目录。
1．命令格式：
`mkdir [选项] 目录...`
2．命令功能：
通过 mkdir 命令可以实现在指定位置创建以 DirName(指定的文件名)命名的文件夹或目录。要创建文件夹或目录的用户必须对所创建的文件夹的父文件夹具有写权限。并且，所创建的文件夹(目录)不能与其父目录(即父文件夹)中的文件名重名，即同一个目录下不能有同名的(区分大小写)。 
3．命令参数：
  -m, --mode=模式，设定权限<模式> (类似 chmod)，而不是 rwxrwxrwx 减 umask
  -p, --parents  可以是一个路径名称。此时若路径中的某些目录尚不存在,加上此选项后,系统将自动建立好那些尚不存在的目录,即一次可以建立多个目录; 
  -v, --verbose  每次创建新目录都显示信息
      --help   显示此帮助信息并退出
      --version  输出版本信息并退出
4．命令实例：
创建一个空目录
命令：
`mkdir test1`

find
find的基本语法格式：
`find  [查找位置]  [查找标准]  [处理动作]`
查找位置：默认为当前目录，可以指定多个目录，多个之间用空格

查找标准：默认为查找指定目录下的所有文件

处理动作：显示到标准输出，默认为print

查找名称为"zookee"开头的文件
`find / -name "zookee*"`


### mv命令

1.作用
mv命令来为文件或目录改名或将文件由一个目录移入另一个目录中。该命令等同于DOS系统下的ren和move命令的组合。它的使用权限是所有用户。
2.格式
mv [options] 源文件或目录 目标文件或目录
3.[options]主要参数
－i：交互方式操作。如果mv操作将导致对已存在的目标文件的覆盖，此时系统询问是否重写，要求用户回答”y”或”n”，这样可以避免误覆盖文件。
－f：禁止交互操作。mv操作要覆盖某个已有的目标文件时不给任何指示，指定此参数后i参数将不再起作用。
4.第二个参数
当第二个参数类型是文件时，mv命令完成文件重命名，它将所给的源文件或目录重命名为给定的目标文件名。
当第二个参数是已存在的目录名称时，源文件或目录参数可以有多个，mv命令将各参数指定的源文件均移至目标目录中。在跨文件系统移动文件时，mv先拷贝，再将原有文件删除，而链至该文件的链接也将丢失。
5.应用实例
(1)将/usr/udt中的所有文件移到当前目录(用”.”表示)中：
`mv /usr/udt/* .`
(2)将文件test.txt重命名为wbk.txt：
`mv test.txt wbk.txt`

(3)把当前目录的一个子目录里的文件移动到另一个子目录里

`mv  文件名/*  另一个目录`

(4)移动当前文件夹下的所有文件到上一级目录

`mv * ../`
(5)把该目录及所有内容一道另一个目录

`mv  目录名/  另一个目录`

例子：将目录A重命名为B

`mv A B`

tail命令
Linux tail命令主要用来从指定点开始将文件写到标准输出。很多人喜欢使用tail –f 来监控日志文件。
命令 格式如下所示
`tail [OPTION]... [FILE]...`

参数如下所示
-f 循环读取


linux重定向
重定向能够实现Linux命令的输入输出与文件之间重定向，以及实现将多个命令组合起来实现更加强大的命令

重定向标准输出

使用`>`可以将本来出现在屏幕的标准输出信息重定向到一个文件中。
用`>>`可以在实现重定向时不覆盖原有内容，而是在文件末尾`追加`内容.

`tail -f  F:\X_Deployment\tomcat8_8080\logs\first.log >> E:\output.txt`


### tree 命令
以图形显示驱动器或路径的文件夹结构

C:\Users\Administrator>tree /?  
以图形显示驱动器或路径的文件夹结构。  
  
`TREE [drive:][path] [/F] [/A]  `
  
   /F   显示每个文件夹中文件的名称。  
   /A   使用 ASCII 字符，而不使用扩展字符。  

`tree . /f > ./tree.txt`


### which从path中找出文件的位置

`which command`

说明
依序从path环境变量所列的目录中找出command的位置，并显示完整路径的名称。在找到第一个符合条件的程序文件时，就立刻停止搜索，省略其余未搜索目录。

范例，找出ls命令的程序文件的位置：
`which ls`

系统输出：
/usr/bin/ls

### whereis找出特定程序的路径

`whereis [option] name`

说明
找出特定程序的可执行文件、源代码文件以及manpage的路径。你所提供的name会被先除去前置的路径以及任何.ext形式的扩展名。

whereis 只会在标准的Linux目录中进行搜索。

常用选项
-b 只搜索可执行文件。

-m 只搜索manpage。

-s 只搜索源代码文件。

-B directory 更改或限定搜索可执行的文件的目录。

-M directory 更改或限定搜索manpage的目录。

-S directory 更改或限定搜索源代码文件的目录。


## VSFTPD

### 配置

#### 允许上传
需要将 /etc/vsftpd.conf 中的 write_enable 值设为 YES，以便允许修改文件系统（如上传）：
`write_enable=YES`

#### 本地用户登录
需要修改 /etc/vsftpd.conf 中的如下值，以便允许 /etc/passwd 中的用户登录:
`local_enable=YES`

#### Chroot 限制
为了阻止用户离开家目录，可以设置 chroot 环境。要启用此功能，请在 /etc/vsftpd.conf 中添加以下行：
`chroot_list_enable=YES`
`chroot_list_file=/etc/vsftpd.chroot_list`
chroot_list_file 定义了被 chroot 限制的用户列表。

#### 端口配置
可能需要调整默认FTP侦听端口和被动模式数据端口：

对于暴露于 Web 的 FTP 服务器，为了减少服务器受到攻击的可能性，可以将侦听端口改为除标准端口 21 以外的端口。
要限制被动模式将打开的端口，可以提供一个范围。
这些端口配置更改可以使用以下几行完成：
```shell
/etc/vsftpd.conf

listen_port=2211
pasv_min_port=5000
pasv_max_port=5003
```

#### 配置 iptables
通常，运行FTP守护进程的服务器受 iptables 防火墙的保护。要允许访问FTP服务器，需要打开相应的端口，如：
`iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 21 -j ACCEPT`


### CentOS中vsftpd的主动和被动方式
FTP是File Transfer Protocol（文件传输协议）的缩写，用来在两台计算机之间互相传送文件。相比于HTTP，FTP协议要复杂得多。复杂的原因，是因为FTP协议要用到两个TCP连接，一个是`命令链路`，用来在FTP客户端与服务器之间传递命令；另一个是`数据链路`，用来上传或下载数据。


PORT & PASV 

    FTP协议有两种工作方式：PORT方式和PASV方式，中文意思为主动式和被动式。 

    PORT（主动）方式的连接过程是：客户端向服务器的FTP端口（默认是21）发送连接请求，服务器接受连接，建立一条命令链路。当需要传送数据时，客户端在命令链路上用PORT命令告诉服务器：“我打开了XXXX端口，你过来连接我”。于是服务器从20端口向客户端的XXXX端口发送连接请求，建立一条数据链路来传送数据。 

    PASV（被动）方式的连接过程是：客户端向服务器的FTP端口（默认是21）发送连接请求，服务器接受连接，建立一条命令链路。当需要传送数据时，服务器在命令链路上用PASV命令告诉客户端：“我打开了XXXX端口，你过来连接我”。于是客户端向服务器的XXXX端口发送连接请求，建立一条数据链路来传送数据。 

    从上面可以看出，两种方式的命令链路连接方法是一样的，而数据链路的建立方法就完全不同。而FTP的复杂性就在于此。 



RedHat
开关机
只要按”Ctrl+C”键就可以中断关机的命令.
Hot Keys
shift + pageDown/pageUp
在控制台翻页查看前面的输出内容

 

## ArchLinux

格式化文件系统并使用swap
仅仅分区是不够的，还需要 mkfs 将分区格式化为指定的文件系统。
先查看所有分区：
`# lsblk /dev/sdx`
如果新创建了 UEFI 系统分区，需要格式化成 fat32 或 vfat32 文件系统，否则无法启动。Windows 双启动系统不要再格式化。
`# mkfs.vfat -F32 /dev/sdxY`
建议用 ext4 文件系统格式化其它分区：
`# mkfs.ext4 /dev/sdxY`
若您分了一个 swap 区，也不要忘了格式化并启用它：
`# mkswap /dev/sdaX`
`# swapon /dev/sdaX`
先挂载 / (root) 分区，其它目录都要在 / 分区中创建然后再挂载。在安装环境中用 /mnt 目录挂载 root：
`# mount /dev/sdxR /mnt`
然后挂载其余单独分区(除了 Swap)，比如 /boot，/var。先创建目录，然后挂载分区：
`# mkdir /mnt/home`
`# mount /dev/sda2 /mnt/home`
建议将 EFI 系统分区挂载到 /mnt/boot，其它方式参阅EFISTUB。
`# mkdir -p /mnt/boot`
`# mount /dev/sdXY /mnt/boot`
挂载好设备，就可以安装 Arch 了.

### Arch Linux更新密钥环
we need to update the archlinux-keyring package.

To do so, run:

`sudo pacman -S archlinux-keyring`

### ArchLinux中使用vsftpd

#### 服务开启命令
检查vsftpd服务是否处于活动状态
`systemctl is-active vsftpd.service`

启动vsftpd服务
`systemctl start vsftpd.service`

停止vsftpd服务
`systemctl stop vsftpd.service`

重新启动vsftpd服务
`systemctl restart vsftpd.service`

`systemctl enable vsftpd.service`

#### 编辑 vsftpd.conf 文件
```shell
[...]
#Uncomment and  Set YES to enable write.
write_enable=YES
[...]
# Uncomment and Set banner name for your website
ftpd_banner=Welcome to Unixmen FTP service.
[...]
# Uncomment
ls_recurse_enable=YES
[...]
# Uncomment and set YES to allow local users to log in.
local_enable=YES
[...]
# To disable anonymous access, set NO.
anonymous_enable=NO
[...]
# Uncomment to enable ascii download and upload.
ascii_upload_enable=YES
ascii_download_enable=YES
[...]
## Add at the end of this  file ##
use_localtime=YES
```

### 在vmware中安装了archlinux网络连接有问题

另外请首先尝试最简单的方案：dhcpcd 网络接口卡名称

## CentOS

### 安装本地源 
`yum --disablerepo=\* --enablerepo=c6-media `

`yum --disablerepo=\* --enablerepo=DVD install -y vim`
其中`-y`代表所有询问都是yes

### 问题描述：
按Ctrl+S键组合冻结终端屏幕。
解决：
这不是一个bug，ctrl-s 是停止字符输出的终端控制字符。键入ctrl-q组合键重新启用终端输出。
这个组合键可能根据不同的终端设置而不同。下面的命令显示当前的设置。
`$ stty -a`

### man命令
manpath

### vi命令
`set nu `显示行号


### shell变量
- 内部变量
- 环境变量
- 用户变量

#### 变量名 
用户变量一般小写

### 变量引用

### vim tab设置为4个空格
在.vimrc中添加以下代码后，重启vim即可实现按TAB产生4个空格：
set ts=4  (注：ts是tabstop的缩写，设TAB宽4个空格)
set expandtab

### shell编程


## Linux系统知识整理

`一切皆文件`


### 用户态和内核态
我们知道Linux系统有用户空间(用户态)和内核空间(内核态)之分，对于x86处理器以及大多数其它处理器，用户空间和内核空间之前的切换是比较耗时(涉及到上下文的保存和恢复，一般3种情况下会发生用户态到内核态的切换：发生系统调用时、产生异常时、中断时)。
