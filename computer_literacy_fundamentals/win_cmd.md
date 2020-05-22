

## Windows操作系统CMD命令行用法总结


windows查看端口占用命令
netstat <command> 
 


1. 查询哪个进程占用了80端口
`netstat -ano | findstr "80" `
TCP    127.0.0.1:80        0.0.0.0:0              LISTENING      1001


3. 根据进程号查询对应进程名称
`tasklist|findstr "1001"`
java.exe                      8760 Console                    2    114,920 K



dir 查看文件
dir [drive:][path][filename] [/A[[:]attributes]] [/B] [/C] [/D] [/L] [/N] [/O[[:]sortorder]] [/P] [/Q] [/R] [/S] [/T[[:]timefield]] [/W] [/X] [/4]
参数：
/O          用分类顺序列出文件。
  排列顺序     N  按名称(字母顺序)     S  按大小(从小到大)
               E  按扩展名(字母顺序)   D  按日期/时间(从先到后)
               G  组目录优先           -  反转顺序的前缀
/Q显示文件及目录属系统哪个用户，
/T:C显示文件创建时间，
/T:A显示文件上次被访问时间，
/T:W上次被修改时间 

``

