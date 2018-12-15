

# Spring调度任务

## 定时任务只运行一次

### 提出问题
是否可以在完全指定的时间安排Spring服务方法一次？
例如,当前时间是下午2点,但是当我按下动作按钮时,我希望我的服务方法从晚上8点开始.



### 基于Spring的TaskScheduler的解决方案

网上寻找的一个不需要太多配置的示例
(ConcurrentTaskScheduler包装一个单线程的预定执行程序)

>The simplest method is the one named schedule that takes a Runnable
and Date only. That will cause the task to run once after the
specified time. All of the other methods are capable of scheduling
tasks to run repeatedly.

简单的工作实例：
```java

    private TaskScheduler scheduler;

    Runnable exampleRunnable = new Runnable() {
        @Override
        public void run() {
            //Thread.sleep(2000);
            record.setVisitState(Constants.STATE_LOGOUT_AUTO);
            record.setLeaveTime(new Date());
            visitorRegisterInfoService.update(record, "scheduledLogout", CommandRecord.IS_TRIGGER);
        }
    };

    /**
     * 设置定时任务进行删除操作
     * @param tokenInfo 可能为null
     */
    @Async
    public void executeScheduledLogoutTask(final VisitorRegisterInfo record, final CommonToken tokenInfo, final Integer domainId) {
        if (null != record.getEndTime()) {
            ScheduledExecutorService localExecutor = Executors.newSingleThreadScheduledExecutor();
            scheduler = new ConcurrentTaskScheduler(localExecutor);

            ScheduledFuture<?> schedule = scheduler.schedule(exampleRunnable, 
                record.getEndTime());//today at 8 pm UTC - replace it with any timestamp in miliseconds to text
        }
    }

```
注意：
>To enable support for @Scheduled and @Async annotations add
@EnableScheduling and @EnableAsync to one of your @Configuration
classes



### 更新/取消计划的任务

TaskScheduler的schedule方法返回一个ScheduledFuture, 它是一个可以取消的延迟结果的动作，
所以为了取消它，你需要保留一个句柄到计划的任务(即保留ScheduledFuture返回对象).

[思路]更改以上代码以取消任务

`在您的executeScheduledLogoutTask方法之外声明ScheduledFuture`
private TaskScheduler scheduler;

`修改您的调用调度以保持返回对象`
scheduledFuture = scheduler.schedule(exampleRunnable, 新日期(1432152000000L));

`在你的代码中某个地方的scheduledFuture对象上调用取消`
boolean mayInterruptIfRunning = true;
scheduledFuture.cancel(mayInterruptIfRunning);



## 总结_spring中定时任务taskScheduler

众所周知在spring 3.0版本后，自带了一个定时任务工具，而且使用简单方便，不用配置文件，可以动态改变执行状态。

被执行的类要实现Runnable接口

### TaskScheduler接口
TaskScheduler是一个接口，TaskScheduler接口下定义了6个方法

1、schedule(Runnable task, Trigger trigger);
指定一个触发器执行定时任务。可以使用CronTrigger来指定Cron表达式，执行定时任务

`CronTrigger t = new CronTrigger("0 0 10,14,16 * * ?");
taskScheduler.schedule(this, t);`

2、schedule(Runnable task, Date startTime);
指定一个具体时间点执行定时任务，可以动态的指定时间，开启任务。只执行一次。（比Timer好用多了。早发现这接口就好了。。。）

3、scheduleAtFixedRate(Runnable task, long period);
立即执行，循环任务，指定一个执行周期（毫秒计时）
PS:不管上一个周期是否执行完，到时间下个周期就开始执行

4、scheduleAtFixedRate(Runnable task, Date startTime, long period);
指定时间开始执行，循环任务，指定一个间隔周期（毫秒计时）
PS:不管上一个周期是否执行完，到时间下个周期就开始执行

5、scheduleWithFixedDelay(Runnable task, long delay);
立即执行，循环任务，指定一个间隔周期（毫秒计时）
PS:上一个周期执行完，等待delay时间，下个周期开始执行

6、scheduleWithFixedDelay(Runnable task, Date startTime, long delay);
指定时间开始执行，循环任务，指定一个间隔周期（毫秒计时）
PS:上一个周期执行完，等待delay时间，下个周期开始执行


#### TaskScheduler下有五个实现类

1、ConcurrentTaskScheduler
以当前线程执行任务。如果任务简单，可以直接使用这个类来执行。快捷方便。

PS:这是单线程运行