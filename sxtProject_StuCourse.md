
## 开发软件
JDK8
Tomcat8.0
Navicat 11.2


## 数据库设计阶段

### 学生选课表
t_student_course

### 教师排课表
t_teacher_course

### MySQL远程IP连接
新增`lbg@%`用户名，密码`lbg`
任意IP，只要用户名/密码验证通过，即可访问

## 编码阶段

### 命名规范
包：
com.lbg.xxx.entity
com.lbg.xxx.controller
...
`xxx为项目名称`

web资源根目录：
WebRoot



### Login登录过滤器白名单
一定会有请求白名单(登录验证请求，验证码请求)

### 图片上传


form 属性enctype
enctype="maltipart/form-data"

### 上传准备
form表单的enctype属性
- application/x-www-form-urlencoded (默认的)提交时以键值对形式
- multipart/form-data 提交时以二进制形式(图片，文件)

### 理解上传思路：

- 稍微复杂一些  直接使用Servlet实现有难度，一般使用apache commons组件中commons-fileUpload组件，大大降低操作的难度。
- commons-fileUpload离不开commons-io组件
- commons-fileUpload的常用类
	+ FileItemFactory    DiskFileItemFactory：工厂类，生产FileItem
	+ FileItem：每个表单项都会被封装成一个FileItem对象
	+ ServletFileUpload：实现上传操作，将表单数据封装到FileItem中


### 控制层
掌握基本步骤：4步


