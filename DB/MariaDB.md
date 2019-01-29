

## 安装

### pacman安装
`pacman -Sy mariadb` 
安装Mariadb软件包之后，你必须运行下面这条命令：
`mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql`

启动 mariadb 守护进程，运行安装脚本，然后重新启动守护进程： 
`# systemctl start mariadb`
`# mysql_secure_installation`
`# systemctl restart mariadb`




## 配置

一旦你启动了MySQL服务器，你最好增加一个root账号来维护你的MySQL用户和数据库。如上面的初始化脚本输出的信息里所述，有手动或自动完成两种方法 ── 可以运行命令来设置root账号的密码，或者运行安全安装脚本。

现在可以使用你偏好的交互方式来进行进一步配置。例如可以用MySQL的命令行工具，以root账号登录你的MySQL服务器： 
`$ mysql -p -u root`

### 添加新用户

以下是创建一个密码为'some_pass'的'monty'用户的示例,并赋予 mydb 完全操作权限：

`$ mysql -u root -p`

```sql
MariaDB> CREATE USER 'monty'@'localhost' IDENTIFIED BY 'some_pass';
MariaDB> GRANT ALL PRIVILEGES ON mydb.* TO 'monty'@'localhost';
MariaDB> FLUSH PRIVILEGES;
MariaDB> quit
```

### 配置文件


MariaDB会按照以下顺序读取配置文件
`/etc/my.cnf /etc/mysql/my.cnf ~/.my.cnf`
请根据你需要的配置作用范围(对系统，对用户...)来修改对应的配置文件.


### 为数据库使用 UTF-8 编码

在 /etc/mysql/my.cnf 的 mysqld 下, 添加:
```shell
[mysqld]
init_connect                = 'SET collation_connection = utf8_general_ci,NAMES utf8'
collation_server            = utf8_general_ci
character_set_client        = utf8
character_set_server        = utf8
```

### 使用内存作为临时文件存放点

MySQL 存储临时文件的目录名是 tmpdir。

创建一个临时目录:

`mkdir -pv /var/lib/mysqltmp`
`chown mysql:mysql /var/lib/mysqltmp`

通过命令找出 mysql 的id和gid:

```shell
id mysql
uid=27(mysql) gid=27(mysql) groups=27(mysql)
```

添加到 /etc/fstab 中。

`tmpfs   /var/lib/mysqltmp   tmpfs   rw,gid=27,uid=27,size=100M,mode=0750,noatime   0 0`

将以下配置添加到 /etc/mysql/my.cnf 的 mysqld 组下:

`tmpdir=/var/lib/mysqltmp`

然后重启系统以使配置生效。 

