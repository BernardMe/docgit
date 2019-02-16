

## Mybatis分页插件

利用AOP实现分页功能可以达到零代码入侵的目的，只需要在请求方法上传入对应的分页请求数据即可，SQL的编写和后台业务逻辑与分页代码没有耦合

### PageHelper

PageHelper是MyBatis的一款分页插件，利用ThreadLocal实现分页功能。PageHelper显示根据你即将发出的SQL语句获取count值(也就是数据总量)，然后获取当前线程上的线程变量进行分页操作。

执行流程
1 使用AOP获取controller方法中分页请求数据PageBean
2 将PageBean保存在ThreadLocal的线程变量中
3 使用AOP拦截dao方法，调用PageHelper的分页方法(使用两次AOP是因为PageHelper只会对即将执行的SQL语句进行分页，假设你要分页的数据是第二顺序执行，这时候则会导致第一顺序执行的SQL语句被分页，而第二顺序执行的SQL语句相反)


### 实例代码

application.yml文件配置:
```yml
spring:
  datasource:
    driver-class-name: com.mysql.jdbc.Driver
    url: jdbc:mysql://localhost:3306/test
    username: root
    password: 123
 
pagehelper:
  helper-dialect: mysql
  reasonable: true
  support-methods-arguments: true
  params:
    count: countSql
  page-size-zero: true
```
注意：我用的SpringBoot本版微2.0.x，在引用数据源的时候用driver-class-name,
      如果是1.5.x版本的话，需要是driverClassName


实体类：
```java
@Data
public class User {
    private Integer id;
    private String name;
    private String code;
    private Long password;
    private boolean status;
}
```



分页工具类：
```java
@Data
public class PageBean<T> {
    // 当前页
    private Integer currentPage;
    // 每页显示的总条数
    private Integer pageSize;
    // 总条数
    private Integer totalNum;
    // 是否有下一页
    private Integer isMore;
    // 总页数
    private Integer totalPage;
    // 开始索引
    private Integer startIndex;
    // 分页结果
    private List<T> items;
}
```

Mapper接口层:
```java
public interface UserMapper {
    @Select("select * from user")
    List<User> selectPage();
 
    @Select("select * from user")
    List<User> selectWithPage();
}
```

注意：此处之所以没有写@Mapper注解是因为，我已经在SpringBoot启动类中已经加上

`@MapperScan(basePackages = {"com.zrl.mapper"})进行声明了`


编写Controller

Controller方法中使用了PageBean接收分页参数或者使用restful风格接收参数，这里并没有限制你必须这么接收，不过你怎么接收分页参数的就需要在aop中怎么拦截并获取，我这里是使用实体类进行接收：
```java
@RestController
@Slf4j
public class UserController {
    @Autowired
    private UserService userService;
 
    @RequestMapping("/select")
    public List<User> selectAll(){
        return userService.selectAll();
    }
 
    @RequestMapping("/selectAllUser/{currentPage}/{pageSize}")
    public PageInfo<User> selectAllUser(@PathVariable("currentPage") Integer currentPage, @PathVariable("pageSize") Integer pageSize){
        return userService.selectAllUser(currentPage,pageSize);
    }
 
    /**
     * 必须要用这两个注解 @PostMapping  @RequestBody
     */
    @PostMapping("/selectAllUserWithPage")
    public PageInfo<User> selectAllUserWithPage(@RequestBody PageBean pageBean){
        return userService.selectAllUserWithPage();
    }
}
```



service层实现类：
```java
@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
 
    @Override
    public List<User> selectAll() {
        return userMapper.selectPage();
    }
 
    @Override
    public PageInfo<User> selectAllUser(Integer currentPage, Integer pageSize) {
        PageHelper.startPage(currentPage,pageSize);
        List<User> userList = userMapper.selectPage();
        PageInfo<User> userPageInfo = new PageInfo<>(userList);
        return userPageInfo;
    }
 
    /**
     * 与selectAllUser(currentPage, pageSize)方法做比较
     * 引用PageHelper.startPage(currentPage,pageSize);这一步，通过AOP前置通知完成，节省代码
     * new PageInfo<>(userList)  这一步理论上也应该能够实现，但我没想到怎么实现，有思路的大神提一下意见 
     * @return
     */
    @Override
    public PageInfo<User> selectAllUserWithPage() {
        return new PageInfo<>(userMapper.selectWithPage());
    }
}
```

编写PageHelperAOP类:
```java
@Component
@Aspect
public class PageHelperAop {
    private static final Logger log = LoggerFactory.getLogger(PageHelperAop.class);
    //使用线程本地变量
    private static final ThreadLocal<PageBean> pageBeanContext = new ThreadLocal<>();
 
    //以WithPage结尾的Controller方法都是需要分页的方法
    @Before(value = "execution(public * com.zrl.controller.*.*WithPage(..))")
    public void controllerAop(JoinPoint joinPoint) throws Exception {
        log.info("Controller正在执行PageHelperAop");
        PageBean pageBean =null;
 
        Object[] args = joinPoint.getArgs();
        //获取类名
        String clazzName = joinPoint.getTarget().getClass().getName();
        //获取方法名称
        String methodName = joinPoint.getSignature().getName();
        //通过反射获取参数列表
        Map<String,Object > nameAndArgs = this.getFieldsName(this.getClass(), clazzName, methodName,args);
 
        pageBean = (PageBean) nameAndArgs.get("pageBean");
        if(pageBean == null){
            pageBean = new PageBean();
            pageBean.setCurrentPage((Integer) nameAndArgs.get("currentPage"));
            pageBean.setPageSize((Integer) nameAndArgs.get("pageSize"));
        }
        //将分页参数放置线程变量中
        pageBeanContext.set(pageBean);
    }
 
    @Before(value = "execution(public * com.zrl.service.impl.*.*WithPage(..))")
    public void serviceImplAop(){
        log.info("Impl正在执行PageHelperAop");
        PageBean pageBean = pageBeanContext.get();
        PageHelper.startPage(pageBean.getCurrentPage(), pageBean.getPageSize());
    }
 
    @AfterReturning(value = "execution(* com.zrl.mapper.*.*WithPage(..))")
    public void mapperAop(){
        log.info("mapper正在执行PageHelperAop");
    }
 
    /**
     * 通过反射获取参数列表
     * @throws Exception
     */
    private Map<String,Object> getFieldsName(Class cls, String clazzName, String methodName, Object[] args) throws Exception {
        Map<String,Object > map=new HashMap<String,Object>();
 
        ClassPool pool = ClassPool.getDefault();
        ClassClassPath classPath = new ClassClassPath(cls);
        pool.insertClassPath(classPath);
 
        CtClass cc = pool.get(clazzName);
        CtMethod cm = cc.getDeclaredMethod(methodName);
        MethodInfo methodInfo = cm.getMethodInfo();
        CodeAttribute codeAttribute = methodInfo.getCodeAttribute();
        LocalVariableAttribute attr = (LocalVariableAttribute) codeAttribute.getAttribute(LocalVariableAttribute.tag);
        if (attr == null) {
            // exception
        }
        int pos = Modifier.isStatic(cm.getModifiers()) ? 0 : 1;
        for (int i = 0; i < cm.getParameterTypes().length; i++){
            map.put( attr.variableName(i + pos),args[i]);
        }
        return map;
    }
}
```

