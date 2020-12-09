




## 数据库
Oracle





### 表空间

TS_IJX

tablespace TS_IJX
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );


### 表



区域表
SYS_REGION_NEW

	REGION_ID VARCHAR2(50) not null	primary key 区域id，主键,
	SUPER_REGION_ID VARCHAR2(50) 父节点区域id,
	REGION_NAME VARCHAR2(50) 区域名称,
	SUPER_REGION_NAME VARCHAR2(50) 父节点区域名称,
	FULL_NAME VARCHAR2(60) 区域全路径名称,
	ISACTIVE NUMBER(2) 是否删除，0 否 1 是,
	REGION_CODE VARCHAR2(50) 区域代码,
	ISLEAF VARCHAR2(10) 是否是叶子节点， 1 是 0 否,
	OTHERID NUMBER(19) constraint UK_OTHERID unique Sys_Region表id,
	REGION_LEVEL NUMBER(10) 区域级别 1 省 2 市 3 县/区,
	Z_RID NUMBER(19) zwtf区域id,
	Z_PID NUMBER(19) zwtf父区域id



------------ 用户库
APP用户表
T_APP_USER

  USER_TYPE NUMBER(2) not null, 用户类型，1教师，2家长
  USER_ID NUMBER(19) not null, 教师或者家长的id
  TEL_NUM VARCHAR2(11),
  LOGIN_TIME TIMESTAMP(6),
  SCHOOL_ID NUMBER(19),
  CLASS_ID NUMBER(19),
  STUDENT_ID NUMBER(19),
  APP_LOGIN_ID NUMBER(19),
  constraint UNIQUE_APP_USER
    unique (USER_TYPE, USER_ID)



学校表
T_SCHOOL

  ID NUMBER(19) not null primary key,
  CHARGE_TIME TIMESTAMP(6) 业务变更时间,
  DORM_TIME VARCHAR2(10 char) 宿舍熄灯时间,
  GROUPID VARCHAR2(20 char) 集团id,
  ISACTIVE NUMBER(10) 是否在线,
  ISKAI VARCHAR2(2 char) 业务开通状态 01 新增 02 终止 03 暂停 04 恢复 05 变更,
  ISUNIFY NUMBER(10) 否全校是否统一考勤 1 是 0 否,
  ISVERIFY NUMBER(10) 是否校验,
  ISWHITE NUMBER(10) 白名单标志 0没有白名单 1全校白名单 2住宿生白名单,
  MARKET_MANAGER VARCHAR2(10 char) 市场负责人姓名,
  MARKET_TELNUM VARCHAR2(12 char) 市场负责人手机号,
  MENWEI_MSG_FLAG NUMBER(1) default 1 门卫信息标志,
  MSGPORT VARCHAR2(15 char)  短信端口号,
  PRODID VARCHAR2(20 char) 时段,
  SCHOOL_CODE VARCHAR2(20 char) 学校编号,
  SCHOOL_DESC VARCHAR2(200 char) 学校描述,
  SCHOOL_NAME VARCHAR2(50 char) 学校名称,
  STATUS NUMBER(10) 收费/适用/未开通,
  SUMMER_END VARCHAR2(10 char) 暑假截至日期,
  SUMMER_START VARCHAR2(10 char) 暑假起始日期,
  WINTER_END VARCHAR2(10 char) 寒假截至日期,
  WINTER_START VARCHAR2(10 char) 寒假起始日期,
  SCHOOL_TYPE_ID NUMBER(19) constraint FK7D59AD9FD03A8886 references SYS_DICT 小学、初中、高中,
  PARENT_ID NUMBER(19) 父级ID,
  REGION_ID NUMBER(19) constraint FK7D59AD9F10158435 references SYS_REGION 区域id,
  ISMANAGER NUMBER(1) default 1 是否纳入卡库管理 默认为1：表示该学校纳入卡库管理  0：表示该学校不纳入卡库管理,
  SCHOOL_NAME_QP VARCHAR2(500) 学校名称全拼,
  SCHOOL_NAME_JP VARCHAR2(500) 学校名称简拼,
  ADD_TIME DATE default SYSDATE 添加时间,
  ORG_ID VARCHAR2(50) 移动分公司id,
  NEW_REGION_ID VARCHAR2(50) SYS_REGION_NEW表的主键region_id,
  M1KBCARDQUOTA NUMBER(10) default 0 M1卡空白卡额度,
  G24KBCARDQUOTA NUMBER(10) default 0 2.4G卡空白卡额度,
  OA_DOMAIN_ID VARCHAR2(32) OA系统学校ID,
  APP_TYPE VARCHAR2(16) default 1 学校类型，1代表i家校类型的学校，2代表云校媒类型的学校，默认为1,
  UPDATE_TIME TIMESTAMP(6) default systimestamp 学校信息更新时间,
  FILL_CARD VARCHAR2(30) 补卡老师,
  FILL_CARD_TELNUM VARCHAR2(40) 补卡老师电话,
  SCHOOL_ADDRESS VARCHAR2(80) 学校地址,
  RECEIVER VARCHAR2(30) 卡品收件人,
  RECEIVER_TELNUM VARCHAR2(40) 卡品收件人联系方式,
  RECEIVER_ADDRESS VARCHAR2(80) 卡品邮寄地址,
  FILLCARD_PLACE VARCHAR2(30) 补卡地点,
  BUSINESS_FLAG NUMBER(1) default 2 业务标识 1：新增 2：正常（默认值） 3：待定 4：终止 5:虚假,
  CUSTOM_LEVEL VARCHAR2(2) 客户等级 A、B、C、D,
  CARD_HARDTYPE NUMBER(19) 卡的硬件类型 1：M1卡 2：2.4G卡 3:915M卡 4：混合,
  CARD_TYPE NUMBER(19) 卡品类型,
  WM_TEACHER_GROUPID NUMBER(19) 微商城老师分组groupID,
  WM_PARENT_GROUPID NUMBER(19) 微商城家长分组groupID,
  TEN_QINPHONE NUMBER(1) default 是否支持10个亲情号码　0:不支持　1:支持,
  VIEW_CREDIT_MALL NUMBER(1) default 是否显示APP积分商城　0:不显示　1:显示,
  SYS_ORG_ID VARCHAR2(64) 组织机构ID,
  SCHOOL_DOCK_CODE VARCHAR2(64) 对接同步学校编号,
  NON_MOBILE_SUPPORT NUMBER(1) default 0 支持非河南移动亲情号 0:不支持 　1:支持,
  SCHOOL_CARD_TYPE NUMBER(1) default 1 学校制卡类型,
  SCHOOL_CARD_NUM NUMBER(4) default 20 学校每次制卡数,
  ISMONITOR NUMBER(10) default '0' not null 在校视频 0 开  1没开,
  YXOPEN_BUSS NUMBER(1) default 0 迎新开通业务方式 1回复短信"是"开通   0 验证码开通,
  ONE_CARTOON_PAY NUMBER(1) default 0 是是否开通一卡通支付 0 否  1 是,
  MESSAGE_FLAG NUMBER(1) default 1 否是否发送开通成功短信.1 是 0 否,
  YKT_MSG NUMBER(1) default 0 是否发送一卡通消费短信 0:学校没有消费短信业务；1:一卡通充值之前发送消费短信的学校; 2:一卡通充值且每周发送短信; 3:一卡通充值不发送短信,
  STUDENT_LOCATION NUMBER default 0 是否开通定位,
  TIME_CONTROL NUMBER(1) default 0 是否启用三时段 0:不启用三时段 1:启用三时段,
  SCHOOL_NATURE NUMBER default 1 学校性质，0 校讯通转型学校  1，一卡通学校，2其他,
  FILL_CARD_FEE NUMBER(10,2) default 10 学校补卡费用,
  REBATE_MONEY NUMBER default 0.5 学校单次补卡返现金额,
  REBATE_ACCOUNT VARCHAR2(50) 补卡老师,
  PAY_METHOD VARCHAR2(10) default 0 支付方式，0 不在线支付，1支付宝支付 ，2微信支付,
  REBATE_ACCOUNT_ADMIN VARCHAR2(50) 管理员,
  REBATE_MONEY_ADMIN NUMBER(10,2) default 5 返佣金额/管理员  默认5,
  LEAVE_TYPE NUMBER(1) default 0 请假类型选择：0基础业务版  1访校版,
  SCHOOL_PAY NUMBER default 0 是否开通校园支付:0全未开通,1开通校园缴费,2开通包餐,3学生钱包
  REBATE_ACCOUNT_NAME VARCHAR2(50) 补卡老师实名姓名,
  REBATE_ACCOUNT_ADMIN_NAME VARCHAR2(50) 管理员实名姓名,
  MSG_SIGN VARCHAR2(50 char) 学校短信签名,
  BILLING_PHONE_FLAG NUMBER(1) 0未开通,1开通,
  IS_SHOW_OPEN_BIZ NUMBER(1) (青于蓝)0:不显示允许孩子打的电话 1:显示允许孩子打的电话,
  INTERACTION_FLAG NUMBER(1) 0,全部1,短信,2 微信,





教师表
T_TEACHER

  ID NUMBER(19) not null
    primary key,
  ADDRESS VARCHAR2(50 char), 住址
  BUKA NUMBER(1) default 0, 是否有补卡权限
  CARDCODE VARCHAR2(20 char), 卡号
  IDENTITY VARCHAR2(18 char), 身份证
  ISACTIVE NUMBER(10), 是否已删除
  LOGIN_IP VARCHAR2(20 char), 登录时IP
  LOGIN_TIME TIMESTAMP(6), 登录时间
  NUM NUMBER(10) default 0, 
  PASSWORD VARCHAR2(40 char), 密码
  SEX NUMBER(10), 性别:0女1男
  SUBJECTIDS VARCHAR2(60 char), 
  SUBJECTNAMES VARCHAR2(20 char), 
  TEACHER_NAME VARCHAR2(30 char), 教师姓名
  TEL_NUM VARCHAR2(40 char), 手机号
  SCHOOL_ID NUMBER(19)
    constraint FK65C3BF17885708CA
      references T_SCHOOL, 学校ID
  DEPARTMENT_ID NUMBER(19),
  TYPE_ID NUMBER(19)
    constraint FK65C3BF1768523A51
      references SYS_DICT, 教师类型:跟sys_dict表中dict_id=2的id类型对应
  NATION_ID NUMBER(19)
    constraint FK65C3BF175EB46324
      references SYS_DICT, 民族
  IS_VIRTUAL_ACCOUNT NUMBER(1) default 0, 是否虚拟账号:0：不是，1：是
  SUBJECT_ID NUMBER(19), 科目ID
  CREATE_TIME DATE default sysdate, 创建时间
  COOKIE VARCHAR2(128), 
  CONFIRMCODE VARCHAR2(10),
  CONFIRMTIME TIMESTAMP(6),
  TEACHER_CODE VARCHAR2(40 char),
  ROLE_ID NUMBER(19) default 0, 角色类型  0:其它  1:学校主管理员  2:普通管理员  3:宿管员 4:年级长  5:班主任 6:普通教师
  TEACHER_IMG VARCHAR2(200), 教师头像
  EMAIL VARCHAR2(32), 电子邮箱
  IS_EMCHAT CHAR default '0', 是否是环信注册用户:0：不是，1：是
  IS_PRINCIPAL CHAR default 0, 是否是校长 0:不是 1:是
  INTRODUCTION VARCHAR2(4000), 教师简介
  HEAD_UPLOAD_TIME TIMESTAMP(6), 教师头像上传时间
  CREATOR VARCHAR2(20), 教师创建者
  IS_DISPLAY CHAR default 1, 是否在教师风采里面展示 1展示 0:不展示
  OA_PERSON_ID VARCHAR2(32), OA系统老师ID
  OA_POST_ID VARCHAR2(32), OA系统岗位ID
  APP_LOGIN_SMS NUMBER(1) default 1, 教师app登录是否需要短信验证，1需要；0不需要
  UPDATE_TIME TIMESTAMP(6) default systimestamp, 教师信息更新时间
  IS_J_KAI NUMBER default 0, J套餐是否开通 0未开 1已开
  W_UID NUMBER(19), 微商城用户ID
  WX_NAME VARCHAR2(64), 微信名
  OPENID VARCHAR2(64), 微信openId
  UNION_ID VARCHAR2(64), 微信unionID
  QQ_NICK_NAME VARCHAR2(64), QQ昵称
  QQ_OPENID VARCHAR2(64), QQopenId
  THELEAD VARCHAR2(1000), 前引导语
  AFTERLEAD VARCHAR2(1000), 后引导语
  IMEI VARCHAR2(64), 手机IMEI
  APP_TIMES NUMBER(19) default 0, App端用户登录次数
  VIEW_CREDIT_MALL NUMBER(1) default 0, 是否显示APP积分商城　0:不显示　1:显示
  WECHAT_USER_ID VARCHAR2(64), 企业号用户id
  BIRTHDAY TIMESTAMP(6), 生日（QYL）
  REGION VARCHAR2(300), 所在地(qyl)
  WX_VS_OPENID VARCHAR2(64), 访校公众号微信用户OpenID
  RESERVE_IS_DEFAULT NUMBER(1) default 0, 是否设为默认身份：0、否，1、是
  LEAVE_IS_DEFAULT NUMBER(1) default 0, 是否设为默认身份：0、否，1、是
  WX_VS_PASSWORD VARCHAR2(40 char) 访校公众号登录密码


学生表
T_STUDENT

  ID NUMBER(19) not null
    primary key,
  ADD_TIME TIMESTAMP(6) default sysdate 增加时间,
  ADDRESS VARCHAR2(50 char) 地址,
  BIRTH VARCHAR2(10 char) 生日,
  CARDCODE VARCHAR2(15 char) 卡号,
  DEMO_QINQING VARCHAR2(40 char) 亲情号码,
  IDENTITY VARCHAR2(18 char) 身份证,
  IN_YEAR VARCHAR2(8 char) 年龄,
  ISACTIVE NUMBER(10) 是否删除，0 删除,1 存在,2 挂起,3 毕业,
  ISBUS NUMBER(10) 是否坐校车，0 无效 1有效,
  ISDORM NUMBER(10) 是否住宿生，0 无效 1有效 2待定,
  IS_GUASHI NUMBER(10) default 0 是否挂失 1 是 0 否,
  IS_KAI NUMBER(10) default 0 是否开通业务: 1:是; 0:否,
  KAI_NUM NUMBER(10) default 0 开通业务数量,
  ORDER_NUM VARCHAR2(14 char) 订购数量,
  REGION_ID NUMBER(19) 区域id,
  SCHOOL_ID NUMBER(19) 学校id,
  SEX NUMBER(10) default 1 性别  1 男   0女,
  STUDENT_CODE VARCHAR2(20 char) 学生代码,
  STUDENT_IMG VARCHAR2(200 char) 学生肖像,
  STUDENT_NAME VARCHAR2(14 char) 学生姓名,
  NATION_ID NUMBER(19) default  1 constraint FK4B9075705EB46324 references SYS_DICT 国籍id,
  CLASS_ID NUMBER(19) constraint FK4B907570B36EDC9 references T_CLASS 班级id,
  CODE_NUM VARCHAR2(14 char) 卡数,
  PHOTO_NAME VARCHAR2(14 char) 照片名字,
  ISTIME1 NUMBER(1) default 0 时段1标志，0 无效 1有效,
  ISTIME2 NUMBER(1) default 0 时段2标志，0 无效 1有效,
  ISTIME3 NUMBER(1) default 0 时段3标志，0 无效 1有效,
  STUDENT_AUTH NUMBER(1) default 0 学生认证：0未认证；1已认证,
  BULK_PASTE_IMG VARCHAR2(125) 学生大头贴(用于APP上面显示的，可以随意修改),
  UUID VARCHAR2(100) constraint UNIQUE_UUID_STUDENT unique app客户端增加学生时的唯一标识,
  UPDATE_TIME TIMESTAMP(6) default systimestamp 学生信息更新时间,
  WX_IMG_COLOR VARCHAR2(50) 学生头像颜色,
  INFO_SOURCE NUMBER(1) 学生信息来源(通过什么方式添加的)，1 ijx平台  2 admin平台  3迎新系统 4迎新小程序,
  AUDIT_STATUS NUMBER(1) default 0 学生图片审核状态  0:未审核 1:审核通过 2未通过（已通知家长） 3未通过（家长已修改）,
  AUDIT_TIME DATE 学生图片更新时间,
  STUDENT_DOCK_CODE VARCHAR2(64) 对接同步学生代码,
  SECOND_ID NUMBER(19) 制卡关联ID,
  CARD_STATUS NUMBER(1) 制卡使用状态  1:已登记， 2:制卡中（admin的加工中）3:配送中 4:正常使用（admin已领卡）这张表只使用 3(未启用)和4(已启用) 5，admin的未处理，ijx的制卡中,
  PRAPE_CARD VARCHAR2(15) 预制卡号,
  SIGNTIME DATE 二次制卡登记时间,
  SIGNER VARCHAR2(15) 二次制卡登记人,
  CASUAL_CARD VARCHAR2(15) 二次制卡临时卡,
  ITEMNUM VARCHAR2(32) 运单号,
  COMPANY VARCHAR2(32) 配送公司,
  COMMITER VARCHAR2(15) 二次制卡提交人,
  COMMITTIME DATE 二次制卡提交时间,
  UP_FLAG NUMBER(2) 升级后,
  BALANCE NUMBER(6,2) 一卡通余额,
  RANK_ID NUMBER(19) 等级Id,
  MAKE_CARD VARCHAR2(20 char) 制卡,
  IMEI VARCHAR2(20) IMEI号,
  YKT_CARD_STATUS NUMBER(10) default 0 一卡通卡状态，0：正常，1挂失,
  AUDIT_ERROR_MSG VARCHAR2(64) default NULL 学生照片审核不通过原因,
  CALL_DURATION NUMBER(5) 通话总时长,
  USED_CALL_DURATION NUMBER(5) 已使用时长
  FACE_FEATURE VARCHAR2(3000) 人脸识别特征码,
  FEATURE_UPDATE_TIME DATE 特征码更新时间,
  CALL_COUNT NUMBER(19) default 0 拨打电话次数,
  ALLOW_CALL NUMBER(1) default 0 0:不允许打电话,1:允许打电话

create index IDX_T_STU_CLA on T_STUDENT (CLASS_ID)
/
create index IDX_STU_SCHDORM on T_STUDENT (SCHOOL_ID, ISACTIVE, ISDORM)
/
create index IDX_STU_CARDCODE  on T_STUDENT (CARDCODE)
/
create unique index U_STUDENT_SCHCARDCODE  on T_STUDENT (CASE  WHEN ("ISACTIVE"=1 AND "CARDCODE" IS NOT NULL) THEN TO_CHAR("SCHOOL_ID")||"CARDCODE" END)
/
create index IDENTITY  on T_STUDENT (IDENTITY)
/
create index IDX_T_STUDENT_STUDENTCODE  on T_STUDENT (STUDENT_CODE)
/


学生家长关联表
T_STUDENT_PARENT


班级表
T_CLASS

  ID NUMBER(19) not null
    primary key, 班级id
  CLASS_NAME VARCHAR2(50 char), 班级名称
  ISACTIVE NUMBER(10), 是否删除 0 删除 1正常 3 毕业
  MONITOR_CODE VARCHAR2(10 char), 班长卡
  SCHOOL_ID NUMBER(19), 学校ID
  TEACHER_ID NUMBER(19)
    constraint FKA014E5EDDA7C2C10
      references T_TEACHER, 班主任教师ID
  GRADE_ID NUMBER(19)
    constraint FKA014E5EDA201C8F0
      references T_GRADE, 年级ID
  CLA_NAME VARCHAR2(255 char), 班级名称（排序用）
  GRA_NAME VARCHAR2(255 char), 年级名称（排序用）
  SCHOOL_NAME VARCHAR2(255 char), 学校名称
  UPDATE_TIME DATE, 升级操作日期
  CLASS_CODE VARCHAR2(40 char), 银达数据库部门编号
  CLASS_NUMBER VARCHAR2(20 char), 序号
  MOB_GROUP_ID NUMBER(19), 环信组ID
  MONITOR_CODE_2 VARCHAR2(10), 副班长卡
  MONITOR_CODE2 VARCHAR2(10 char), 副班长卡
  SYS_ORG_ID VARCHAR2(64), 组织机构ID
  CLASS_DOCK_CODE VARCHAR2(64), 对接同步班级编号
  REPAIR_ID VARCHAR2(255), 报修学生ID
  CLASS_IMG VARCHAR2(200 char), (青与蓝项目)班级头像地址
  ISLOCK VARCHAR2(1) (青与蓝项目)0:未锁,1:已锁



年级表
T_GRADE


年级长信息表
T_GRADE_TEACHER

  GRADE_ID NUMBER(19) not null, 年级id
  TEACHER_ID NUMBER(19) not null 教师id


宿舍表
T_DORM

  ID NUMBER(19) not null
    primary key,
  DORM_NAME VARCHAR2(30 char),
  DORM_TYPE NUMBER(10),
  NUM NUMBER(10) default 99,
  REMAIN_NUM NUMBER(10) default 66,
  LAYER_ID NUMBER(19)
    constraint FKCB5C04F1FCB99B30
      references T_LAYER,
  ISACTIVE NUMBER(10) default 1




RELATIONSHIP 家长与孩子关系 0:默认不显示 参考 AppParentRelationType枚举 1:爸爸 2:妈妈 3:其他家长


角色表
T_ROLE

ROLE_TYPE 角色类型 1:超级管理员(学校主管理员)  2:普通管理员 3:宿管理员 4:年级长 5:班主任 6:普通教师

```sql
SELECT T.SCHOOL_ID,
       T.TEACHER_NAME,
       T.TEL_NUM,
       R.ROLE_NAME
FROM T_TEACHER T, T_ROLE R
WHERE T.ROLE_ID = R.ID
AND R.ROLE_TYPE=1
AND T.ISACTIVE = 1
AND T.SCHOOL_ID = R.SCHOOL_ID
--
and T.SCHOOL_ID=#{学校ID}
;
```

课程教师表
T_COURSE_TEACHER


任课教师表
T_TEACHER_CLASSTEACHER_SUBJECT

  ID NUMBER(19) not null, 
  SCHOOL_ID NUMBER(19), 学校ID
  GRADE_ID NUMBER(19), 年级ID
  CLASS_ID NUMBER(19), 班级ID
  SUBJECT_NAME VARCHAR2(100), 科目名字
  TEACHER_NAME VARCHAR2(100), 任课老师名字
  TEL_NUM VARCHAR2(50), 手机号
  TEACHER_ID NUMBER(19) 老师表ID


学校动态信息表，包括【学校公告】 【新闻动态】 【教育咨询】 【学校介绍】
T_SCHOOL_STATE

  ID NUMBER(19) not null primary key seq_school_state,
  SCHOOL_ID NUMBER(19) 学校id,
  STATE_TITLE VARCHAR2(1000 char) 标题,
  STATE_BANNER VARCHAR2(1000 char) 主题图片,
  STATE_CONTENT_OLD VARCHAR2(4000 char) 内容1(已换为clob类型，可删除),
  RELEASE_TIME DATE default sysdate 发布时间,
  RELEASE_TEACHER_ID NUMBER(19) 发布人id,
  ISACTIVE NUMBER(1) default 1 是否有效 1是 0否,
  STATE_TYPE NUMBER(2) 类型 1学校公告 2新闻动态 3教育咨询 4学校介绍 5团员生活 6少先队员 7生活监控 8特色教学 9欢乐时光 10联系我们 11校友寄语 12光荣榜,
  UPDATE_TEACHER_ID NUMBER(19) 更新人id,
  UPDATE_TIME DATE 更新时间,
  STATE_CONTENT2 CLOB 存储大文本数据,
  STATE_CONTENT CLOB 内容1


------------ 业务开通

学生业务信息表
T_BUSINESS

  ID NUMBER(19) not null primary key,
  CLASS_ID NUMBER(19) 班级ID,
  FEE_TIME TIMESTAMP(6) 计费生效时间,
  FLAG NUMBER(10) 签约标志,
  GROUPID VARCHAR2(20 char) not null 集团客户ID,
  GROUP_UPDATE_TIME TIMESTAMP(6) 集团客户业务变更时间,
  OPERATE VARCHAR2(8 char) 操作代码:03 开通，04 取消 05 升级,
  PARENT_ID NUMBER(19) 家长ID,
  PING_AN NUMBER(10) default 0 平安短信业务开通标志,
  PRODUCT_CODE VARCHAR2(8 char) 套餐编号，全网通：N 未开通 Y 开通,
  QIN_QING NUMBER(10) default 0 亲情电话业务开通标志,
  SCHOOL_ID NUMBER(19) 学校ID,
  STATUS NUMBER(10) 生效状态:0:未开通,1:正式开通,2:试用开通,非移动开通：未开通 3 N 开通 4 Y,
  STATUS_TIME TIMESTAMP(6) 业务生效时间,
  STUDENT_ID NUMBER(19) 学生ID,
  TELNUM VARCHAR2(20 char) 家长手机号,
  XUN_HU NUMBER(10) default 0 寻呼业务开通标志,
  PRODUCT_ID NUMBER(19) constraint FK7251332B1A82F2B1 references T_PRODUCT 办理套餐,
  PRODUCT_CODE_OLD VARCHAR2(8 char) 旧套餐编号,
  REGION VARCHAR2(10 char) 区域,
  FEE_TYPE NUMBER(10) 计费类型: 0:立即计费 1:免费体验,
  ORDER_TYPE NUMBER(10) 订购方式:0:免二次确认订购1:二次确认订购2:验证码订购,
  NEW_ECID VARCHAR2(20) 新集团ID,
  SOURCESOFDATA NUMBER(10) 数据来源:空:ftp 1:http,
  STATUS_END_TIME TIMESTAMP(6) 业务结束时间,
  TEL_TYPE NUMBER(10) 手机号运营商：1:河南移动 2非河南移动 3:联通 4:电信,
  UUID VARCHAR2(32 char) default NULL 对应非河南移动业务表信息


------------ 考勤管理



学生考勤基础表
T_ATTENTANCE_GATE_HIS

	LOGDATE DATE not null,
	ID NUMBER(20) not null,
	AFTER_BEDTIME NUMBER(20) 入寝后考勤,
	AS_CLASS NUMBER(20) 下午教学时段考勤,
	ATTENTANCE_DATE VARCHAR2(20) 考勤日期,
	BEFOR_BEDTIME NUMBER(20) 入寝前考勤,
	GRADE_ID NUMBER(20) 年级id,
	MS_BEFOR_CLASS NUMBER(20) 早上上课前考勤,
	MS_CLASS NUMBER(20) 早上教学时段考勤,
	NS_CLASS NUMBER(20) 晚自习教学时段考勤,
	PERSON_TYPE NUMBER(20) 人员类型,
	SCHOOL_ID NUMBER(20) 学校id,
	CLASS_ID NUMBER(19) 班级id,
	STUDENT_ID NUMBER(19) 学生id,
	AS_BEFOR_CLASS0 NUMBER(1) 中午出校,
	AS_BEFOR_CLASS1 NUMBER(1) 中午进校,
	NS_BEFOR_CLASS0 NUMBER(1) 晚上出校,
	NS_BEFOR_CLASS1 NUMBER(1) 晚上进校,
	MS_BEFOR_CLASS_TIME DATE 早上上课前考勤打卡时间,
	MS_CLASS_TIME DATE 早上教学时段考勤打卡时间,
	AS_BEFOR_CLASS_TIME DATE 中午进校打卡时间,
	AS_CLASS_TIME DATE 下午教学时段考勤打卡时间,
	NS_BEFOR_CLASS_TIME DATE 晚上进校打卡时间,
	NS_CLASS_TIME DATE 晚自习教学时段考勤打卡时间,
	BEFOR_BEDTIME_TIME DATE 入寝后考勤打卡时间,
	AS_BEFOR_CLASS_TIME1 DATE 中午出校打卡时间,
	NS_BEFOR_CLASS_TIME1 DATE 晚上出校打卡时间


出入校当天统计表
T_ATTANCE_GATE_SUM

  ID NUMBER,
  SCHOOL_ID NUMBER(20) 学校id,
  GRADE_ID NUMBER 年级id,
  CLASS_ID NUMBER 班级id,
  SCHOOL_NAME VARCHAR2(50 char) 学校,
  GRADE_NAME VARCHAR2(30 char) 年级,
  CLASS_NAME VARCHAR2(20 char) 班级,
  PERSON_TYPE NUMBER 人员类型(0:走读生 1:住宿生 null:全部),
  STU_CNT NUMBER 学生人数,
  MS_START_NOCARD NUMBER 早上上课前未刷卡人数,
  MS_START_CARDOUT NUMBER 早上上课前刷卡出人数,
  MS_START_CARDIN NUMBER 早上上课前刷卡入人数,
  MS_CLASS_NOCARD NUMBER 早上教学时段未刷卡人数,
  MS_CLASS_CARDOUT NUMBER 早上教学时段刷卡出人数,
  MS_CLASS_CARDIN NUMBER 早上教学时段刷卡入人数,
  AS_START_NOCARD NUMBER 下午上课前未刷卡人数,
  AS_START_CARDOUT NUMBER 下午上课前刷卡出人数,
  AS_START_CARDIN NUMBER 下午上课前刷卡入人数,
  AS_CLASS_NOCARD NUMBER 下午教学时段未刷卡人数,
  AS_CLASS_CARDOUT NUMBER 下午教学时段刷卡出人数,
  AS_CLASS_CARDIN NUMBER 下午教学时段刷卡入人数,
  NS_START_NOCARD NUMBER 晚自习上课前未刷卡人数,
  NS_START_CARDOUT NUMBER 晚自习上课前刷卡出人数,
  NS_START_CARDIN NUMBER 晚自习上课前刷卡入人数,
  NS_CLASS_NOCARD NUMBER 晚自习教学时段未刷卡人数,
  NS_CLASS_CARDOUT NUMBER 晚自习教学时段刷卡出人数,
  NS_CLASS_CARDIN NUMBER 晚自习教学时段刷卡入人数,
  NS_AFTER_NOCARD NUMBER 晚自习放学后未刷卡人数,
  NS_AFTER_CARDOUT NUMBER 晚自习放学后刷卡出人数,
  NS_AFTER_CARDIN NUMBER 晚自习放学后刷卡入人数,
  MARK NUMBER 级别标志,
  ATTENTANCE_DATE VARCHAR2(10) 考勤日期


请假配餐关系表
T_REST_NOMEAL

  ID NUMBER(19) not null primary key 主键ID,  
  STUDENT_ID NUMBER(19) not null 学生id,
  REST_ID NUMBER(19) not null 请假ID,  
  NOMEAL_DAY DATE 请假期间无需配餐的日期


请假表
T_REST

  ID NUMBER(19) not null primary key 唯一流水ID,  
  SCHOOL_ID NUMBER(19) not null 学校id,
  GRADE_ID NUMBER(19) not null 年级id,
  CLASS_ID NUMBER(19) not null 班级id,
  STUDENT_ID NUMBER(19) not null 学生id,
  TEACHER_ID NUMBER(19) 班主任id,
  ISACTIVE NUMBER(1) default 1 删除状态: 0 是 1 否,
  STARTDATE DATE not null 请假开始时间,
  ENDDATE DATE not null 请假结束时间,
  RESETDATE DATE 请假延时时间,
  INSERT_PERSON VARCHAR2(50) 登记人,
  INSERT_TIME DATE default SYSDATE 数据入库时间, 即登记时间，即操作时间,
  TYPE VARCHAR2(10) 请假类型 1:事假 2:病假 3:其他,
  REASON VARCHAR2(2000) 请假原因,
  FLAG NUMBER(1) '请假状态: 0 失效 1 有效 2 销假,
  PROCESS_INSTANCE_ID NUMBER(19) 流程实例ID,
  UPDATEDATE DATE 更新日期,
  APPROVE_OPINION VARCHAR2(100) 审批意见,
  ISAPPROVE CHAR default 0 是否需要审核,
  APPROVE_STATE CHAR default 0 审批状态  0:无需审核 1:审批中 2:已通过 3:已拒绝,
  HOURS VARCHAR2(30) 请假小时数,
  INSERT_PERSON_TYPE CHAR 登记人类型  1:家长 0:老师,
  ISURGE CHAR 是否已催促　 1:是 0:否,
  IS_LEAVE CHAR default 0 是否离校 0 是  1 否
  NOMEAL_DAY_STR VARCHAR2(500) 请假期间无需配餐的日期字符串


考勤规则表
T_ATTENTANCE_RULE

  ID NUMBER(19) not null primary key 考勤规则ID,
  ADD_TIME TIMESTAMP(6) 数据增加时间,
  SCHOOL_ID NUMBER(19) constraint FK663FD6B7885708CA references T_SCHOOL 学校ID,
  PERSON_TYPE NUMBER(10) 人员类型(0:走读生 1:住宿生),
  ATTENTANCE_DESC VARCHAR2(30) 考勤描述,
  ATTENTANCE_FLAG NUMBER(19) 考勤标志(不同级别对应的ID),
  ATTENTANCE_LEVEL NUMBER(10) 考勤级别(1:班级 2:年级 3:学校) 优化级别:1,2,3,
  DORM_BED_TIME VARCHAR2(6 char) 住宿生就寝时间,
  MS_START_TIME VARCHAR2(6 char) 早上上课开始时间,
  MS_OVER_TIME VARCHAR2(6 char) 早上放学时间,
  MS_TEACHER_TIME VARCHAR2(6 char) 早上教师推送短信时间,
  MS_OVER_PRENT_TIME VARCHAR2(6) 截至早上上课开始时间后延时间点通知家长学生未刷卡推送短信时间,
  MS_OVER_PRENT_FLAG NUMBER(10) 截至早上上课开始时间后延时间点通知家长学生未刷卡推送短信中未订购业务的标志位，0：发短信,
  MS_PUSH_NGZ NUMBER(1) default 0 今早上学是否推送给年级长0否1是,
  AS_START_TIME VARCHAR2(6 char) 下午上课开始时间,
  AS_OVER_TIME VARCHAR2(6 char) 下午放学时间,
  AS_TEACHER_TIME VARCHAR2(6) 下午教师推送短信时间,
  AS_PUSH_NGZ NUMBER(1) default 0 下午上学是否推送给年级长0否1是,
  NS_START_TIME VARCHAR2(6 char) 晚自习上课开始时间,
  NS_OVER_TIME VARCHAR2(6 char) 晚自习放学时间,
  NS_TEACHER_TIME VARCHAR2(6 char) 晚寝教师推送短信时间,
  UPDATE_TIME TIMESTAMP(6) 数据更新时间,
  BED_TEACHER_TIME VARCHAR2(6) 晚自习放学教师推送短信时间,
  NS_OVER_END_TIME VARCHAR2(6) 晚自习放学统计截止时间,
  NS_SCLMANAGER_TIME VARCHAR2(6) 晚自习放学学校宿舍管理员推送短信时间,
  BED_PUSH_NGZ NUMBER(1) default 0 晚自习放学是否推送给年级长0否1是


学生考勤基础表
T_ATTENTANCE_GATE

  ID NUMBER(20) not null,
  AFTER_BEDTIME NUMBER(20) 入寝后考勤,
  AS_CLASS NUMBER(20) 下午教学时段考勤,
  ATTENTANCE_DATE VARCHAR2(20) 考勤日期,
  BEFOR_BEDTIME NUMBER(20) 入寝前考勤,
  GRADE_ID NUMBER(20) 年级ID,
  MS_BEFOR_CLASS NUMBER(20) 早上上课前考勤,
  MS_CLASS NUMBER(20) 早上教学时段考勤,
  NS_CLASS NUMBER(20) 晚自习教学时段考勤,
  PERSON_TYPE NUMBER(20) 人员类型,
  SCHOOL_ID NUMBER(20) 学校ID,
  CLASS_ID NUMBER(19) 班级ID,
  STUDENT_ID NUMBER(19) 学生ID,
  AS_BEFOR_CLASS0 NUMBER(1) 中午出校,
  AS_BEFOR_CLASS1 NUMBER(1) 中午进校,
  NS_BEFOR_CLASS0 NUMBER(1) 晚上出校,
  NS_BEFOR_CLASS1 NUMBER(1) 晚上进校,
  MS_BEFOR_CLASS_TIME DATE 早上上课前考勤打卡时间,
  MS_CLASS_TIME DATE 早上教学时段考勤打卡时间,
  AS_BEFOR_CLASS_TIME DATE 中午进出校打卡时间,
  AS_CLASS_TIME DATE 下午教学时段考勤打卡时间,
  NS_BEFOR_CLASS_TIME DATE 晚上进出校打卡时间,
  NS_CLASS_TIME DATE 晚自习教学时段考勤打卡时间,
  BEFOR_BEDTIME_TIME DATE 入寝后考勤打卡时间,
  AS_BEFOR_CLASS_TIME1 DATE 中午出校打卡时间,
  NS_BEFOR_CLASS_TIME1 DATE 晚上出校打卡时间


今日请假统计表
T_QYL_LEAVE_STATISTICS_TODAY

  ID NUMBER(20) not null 主键,
  SCHOOL_ID NUMBER(20) 学校ID,
  GRADE_ID NUMBER(20) 年级ID,
  CLASS_ID NUMBER(20) 班级ID,
  PERSON_TYPE NUMBER(1) 人员类型(0:走读生 1:住宿生),
  MS_START_LEAVE NUMBER(5) 早上上课前请假人数,
  MS_CLASS_LEAVE NUMBER(5) 早上教学时段请假人数,
  AS_START_LEAVE NUMBER(5) 下午上课前请假人数,
  AS_CLASS_LEAVE NUMBER(5) 下午教学时段请假人数,
  NS_START_LEAVE NUMBER(5) 晚自习上课前请假人数,
  NS_CLASS_LEAVE NUMBER(5) 晚自习教学时段请假人数,
  NS_AFTER_LEAVE NUMBER(5) 晚自习放学后请假人数


历史请假统计表
T_QYL_LEAVE_STATISTICS_HISTORY

  ID NUMBER(20) not null 主键,
  SCHOOL_ID NUMBER(20) 学校ID,
  GRADE_ID NUMBER(20) 年级ID,
  CLASS_ID NUMBER(20) 班级ID,
  PERSON_TYPE NUMBER(1) 人员类型(0:走读生 1:住宿生),
  MS_START_LEAVE NUMBER(5) 早上上课前请假人数,
  MS_CLASS_LEAVE NUMBER(5) 早上教学时段请假人数,
  AS_START_LEAVE NUMBER(5) 下午上课前请假人数,
  AS_CLASS_LEAVE NUMBER(5) 下午教学时段请假人数,
  NS_START_LEAVE NUMBER(5) 晚自习上课前请假人数,
  NS_CLASS_LEAVE NUMBER(5) 晚自习教学时段请假人数,
  NS_AFTER_LEAVE NUMBER(5) 晚自习放学后请假人数,
  STATISTICS_DATE VARCHAR2(20) 统计日期


宿舍考勤规则表
T_ATTENTANCE_RULE_DORM

  ID NUMBER(19) not null primary key 考勤id,
  ADD_TIME DATE default sysdate 数据增加时间,
  UPDATE_TIME DATE default sysdate 数据更新时间,
  ATTENTANCE_DESC VARCHAR2(80) 考勤描述,
  SCHOOL_ID NUMBER(19) constraint FK_T_ATT_RULE_DORM_SCHL_ID references T_SCHOOL 学校id,
  ATTENTANCE_FLAG NUMBER(19) not null 考勤标志(不同级别对应的id),
  ATTENTANCE_LEVEL NUMBER(10) not null 考勤级别(1:年级 2:学校  0:宿舍楼)优化级别:1,2,
  ZAO_OUT_OPEN_TIME VARCHAR2(6) 早晨出寑开门时间,
  ZAO_OUT_CLOSE_TIME VARCHAR2(6) 早晨出寑关门时间,
  ZHG_IN_OPEN_TIME VARCHAR2(6) 中午入侵开门时间,
  ZHG_IN_CLOSE_TIME VARCHAR2(6) 中午入侵关门时间,
  ZHG_OUT_OPEN_TIME VARCHAR2(6) 中午出寑开门时间,
  ZHG_OUT_CLOSE_TIME VARCHAR2(6) 中午出寑关门时间,
  WAN_IN_OPEN_TIME VARCHAR2(6) 晚上入侵开门时间,
  WAN_IN_CLOSE_TIME VARCHAR2(6) 晚上入侵关门时间,
  ZAO_OUT_SEND_TIME VARCHAR2(6) 早晨出寑推送时间,
  ZHG_IN_SEND_TIME VARCHAR2(6) 中午入侵推送时间,
  ZHG_OUT_SEND_TIME VARCHAR2(6) 中午出寑推送时间,
  WAN_IN_SEND_TIME VARCHAR2(6) 晚上入侵推送时间,
  ZAO_OUT_PUSH_ADMIN VARCHAR2(200) 早上出寝推送管理员id(多个以,号间隔),
  ZAO_OUT_PUSH_BZR NUMBER(1) 早上出寝是否推送给班主任0否1是,
  ZHG_IN_PUSH_ADMIN VARCHAR2(200) 中午入寝推送管理员id(多个以,号间隔),
  ZHG_IN_PUSH_BZR NUMBER(1) 中午入寝是否推送给班主任0否1是,
  ZHG_OUT_PUSH_ADMIN VARCHAR2(200) 中午出寝推送管理员id(多个以,号间隔),
  ZHG_OUT_PUSH_BZR NUMBER(1) 中午出寝是否推送给班主任0否1是,
  WAN_IN_PUSH_ADMIN VARCHAR2(200) 晚上入寝推送管理员id(多个以,号间隔),
  WAN_IN_PUSH_BZR NUMBER(1) 晚上入寝是否推送给班主任0否1是,
  ZAO_OUT_PUSH_NGZ NUMBER(1) default 0 早上出寝是否推送给年级长0否1是,
  ZHG_IN_PUSH_NGZ NUMBER(1) default 0 中午入寝是否推送给年级长0否1是,
  ZHG_OUT_PUSH_NGZ NUMBER(1) default 0 中午出寝是否推送给年级长0否1是,
  WAN_IN_PUSH_NGZ NUMBER(1) default 0 晚上入寝是否推送给年级长0否1是,
  ZAO_OUT_PUSH_SGY NUMBER(1) default 0 早上出寝推送宿管员,
  ZHG_IN_PUSH_SGY NUMBER(1) default 0 中午入寝推送宿管员,
  ZHG_OUT_PUSH_SGY NUMBER(1) default 0 中午出寝推送宿管员,
  WAN_IN_PUSH_SGY NUMBER(1) default 0 晚上入寝推送宿管员 


新宿舍考勤刷卡明细表
T_KAOQIN_DORM_NEW

  ID NUMBER(19) not null primary key 考勤序列id,
  ISACTIVE NUMBER(1) default 1 是否有效,
  BED_ID NUMBER(19) constraint FK_T_KAOQIN_DORM_NEW_BEDID references T_BED 床位id,
  FLOOR_ID NUMBER(19) 宿舍楼id,
  LAYER_ID NUMBER(19) 楼层id,
  DORM_ID NUMBER(19) 宿舍id,
  FLOOR_NAME VARCHAR2(100) 宿舍楼名称,
  LAYER_NAME VARCHAR2(100) 楼层名称,
  DORM_NAME VARCHAR2(100) 宿舍名称,
  STUDENT_ID NUMBER(19) 学生id,
  CLASS_ID NUMBER(19) 班级id,
  GRADE_ID NUMBER(19) 年级id,
  SCHOOL_ID NUMBER(19) 学校id,
  CLASS_NAME VARCHAR2(100) 班级名称,
  GRADE_NAME VARCHAR2(100) 年级名称,
  SCHOOL_NAME VARCHAR2(100) 学校名称,
  KAOQIN_DATE VARCHAR2(15) 考勤日期,
  ZO_MS_CARD_FLAG NUMBER(1) default -1 凌晨0点到早寝开门时段刷卡方向 -1未刷卡 0出 1进 5请假,
  ZO_MS_CARD_TIME DATE 凌晨0点到早寝开门时段刷卡时间,
  ZO_MS_KAOQIN_RESULT NUMBER(1) default 0 5请假,
  ZO_MS_TERMINAL_NUM VARCHAR2(15) 凌晨0点到早寝开门时段刷卡终端编号,
  MS_CARD_FLAG NUMBER(1) default -1 早寝开门到关门时段刷卡方向 -1未刷卡 0出 1进 5请假,
  MS_CARD_TIME DATE 早寝开门到关门时段刷卡时间,
  MS_KAOQIN_RESULT NUMBER(1) default 0 0未刷,1正常,2异常,5请假,
  MS_TERMINAL_NUM VARCHAR2(15) 早寝开门到关门时段刷卡终端编号,
  MS_ZIS_CARD_FLAG NUMBER(1) default -1 早寝出寑关门到中午入侵之间时段刷卡方向 -1未刷卡 0出 1进 5请假,
  MS_ZIS_CARD_TIME DATE 早寝出寑关门到中午入侵之间时段刷卡时间,
  MS_ZIS_KAOQIN_RESULT NUMBER(1) default 0 0未刷,1正常,2异常,5请假,
  MS_ZIS_TERMINAL_NUM VARCHAR2(15) 早寝出寑关门到中午入侵之间时段刷卡终端编号,
  ZIS_CARD_FLAG NUMBER(1) default -1 中午入寝开门到关门时段刷卡方向 -1未刷卡 0出 1进 5请假,
  ZIS_CARD_TIME DATE 中午入寝开门到关门时段刷卡时间,
  ZIS_KAOQIN_RESULT NUMBER(1) default 0 0未刷,1正常,2异常,5请假,
  ZIS_TERMINAL_NUM VARCHAR2(15) 中午入寝开门到关门时段刷卡终端编号,
  ZIS_ZOS_CARD_FLAG NUMBER(1) default -1 中午入侵关门到中午出寑开门时段刷卡方向 -1未刷卡 0出 1进 5请假,
  ZIS_ZOS_CARD_TIME DATE 中午入寝关门到中午出寑开门时段刷卡时间,
  ZIS_ZOS_KAOQIN_RESULT NUMBER(1) default 0 0未刷,1正常,2异常,5请假,
  ZIS_ZOS_TERMINAL_NUM VARCHAR2(15) 中午入寝关门到中午出寑开门时段刷卡终端编号,
  ZOS_CARD_FLAG NUMBER(1) default -1 中午出寝开门到关门时段刷卡方向 -1未刷卡 0出 1进 5请假,
  ZOS_CARD_TIME DATE 中午出寝开门到关门时段刷卡时间,
  ZOS_KAOQIN_RESULT NUMBER(1) default 0 0未刷,1正常,2异常,5请假,
  ZOS_TERMINAL_NUM VARCHAR2(15) 中午出寝开门到关门时段刷卡终端编号,
  ZOS_NS_CARD_FLAG NUMBER(1) default -1 中午出寝关门到晚寝入侵开门时段刷卡方向 -1未刷卡 0出 1进 5请假,
  ZOS_NS_CARD_TIME DATE 中午出寝关门到晚寝入侵开门时段刷卡时间,
  ZOS_NS_KAOQIN_RESULT NUMBER(1) default 0 0未刷,1正常,2异常,5请假,
  ZOS_NS_TERMINAL_NUM VARCHAR2(15) 中午出寝关门到晚寝入侵开门时段刷卡终端编号,
  NS_CARD_FLAG NUMBER(1) default -1 晚寝入侵开门到关门时段刷卡方向 -1未刷卡 0出 1进 5请假,
  NS_CARD_TIME DATE 晚寝入侵开门到关门时段刷卡时间,
  NS_KAOQIN_RESULT NUMBER(1) default 0 0未刷,1正常,2异常,5请假,
  NS_TERMINAL_NUM VARCHAR2(15) 晚寝入侵开门到关门时段刷卡终端编号,
  NS_ZO_CARD_FLAG NUMBER(1) default -1 晚寝入侵关门到凌晨0点时段刷卡方向 -1未刷卡 0出 1进 5请假,
  NS_ZO_CARD_TIME DATE 晚寝入侵关门到凌晨0点时段刷卡时间,
  NS_ZO_KAOQIN_RESULT NUMBER(1) default 0 0未刷,1正常,2异常,5请假,
  NS_ZO_TERMINAL_NUM VARCHAR2(15) 晚寝入侵关门到凌晨0点时段刷卡终端编号,
  RESTFLAG NUMBER(1) 当天是否请假,
  RESTSTARTTIME DATE 请假开始时间,
  RESTENDTIME DATE 请假结束时间,
  CHGRFLAG CHAR 信息更改标识 1 新增 2 修改 3 删除


新版宿舍考勤按班级统计表(当天早寝开门以后)
T_KQDORM_BYCLS_NEW

  LOGDATE DATE not null 统计日期,
  SCHOOL_ID NUMBER(19) 学校id,
  SCHOOL_NAME VARCHAR2(50) 学校名称 + 合计,
  GRADE_ID NUMBER(19) 年级id,
  GRADE_NAME VARCHAR2(50) 年级名称 + 小计,
  CLASS_ID NUMBER(19) 班级id,
  CLASS_NAME VARCHAR2(50) 班级名称 + 小计,
  STU_CNT NUMBER(20) 学生总数,
  ZO_MS_CARD_IN_NUM NUMBER(20) 凌晨0点到明晨早寝出寑开门时段进人数,
  ZO_MS_CARD_OUT_NUM NUMBER(20) 凌晨0点到明晨早寝出寑开门时段出人数,
  MS_CARD_IN_NUM NUMBER(20) 早寝开门到关门时段进人数,
  MS_CARD_OUT_NUM NUMBER(20) 早寝开门到关门时段出人数,
  MS_CARD_NOCARD_NUM NUMBER(20) 早寝开门到关门时段未刷卡人数,
  MS_ZIS_CARD_IN_NUM NUMBER(20) 早寝出寑关门到中午入侵时段进人数,
  MS_ZIS_CARD_OUT_NUM NUMBER(20) 早寝出寑关门到中午入侵时段出人数,
  ZIS_CARD_IN_NUM NUMBER(20) 中午入寝开门到关门时段进人数,
  ZIS_CARD_OUT_NUM NUMBER(20) 中午入寝开门到关门时段出人数,
  ZIS_CARD_NOCARD_NUM NUMBER(20) 中午入寝开门到关门时段未刷卡人数,
  ZIS_ZOS_CARD_IN_NUM NUMBER(20) 中午入侵关门到中午出寑开门时段进人数,
  ZIS_ZOS_CARD_OUT_NUM NUMBER(20) 中午入侵关门到中午出寑开门时段出人数,
  ZOS_CARD_IN_NUM NUMBER(20) 中午出寝开门到关门时段进人数,
  ZOS_CARD_OUT_NUM NUMBER(20) 中午出寝开门到关门时段出人数,
  ZOS_CARD_NOCARD_NUM NUMBER(20) 中午出寝开门到关门时段未刷卡人数,
  ZOS_NS_CARD_IN_NUM NUMBER(20) 中午出寝关门到晚寝入侵开门时段进人数,
  ZOS_NS_CARD_OUT_NUM NUMBER(20) 中午出寝关门到晚寝入侵开门时段出人数,
  NS_CARD_IN_NUM NUMBER(20) 晚寝入侵开门到关门时段进人数,
  NS_CARD_OUT_NUM NUMBER(20) 晚寝入侵开门到关门时段出人数,
  NS_CARD_NOCARD_NUM NUMBER(20) 晚寝入侵开门到关门时段未刷卡人数,
  NS_ZO_CARD_IN_NUM NUMBER(20) 晚寝入侵关门到凌晨0点时段进人数,
  NS_ZO_CARD_OUT_NUM NUMBER(20) 晚寝入侵关门到凌晨0点时段出人数,
  MARK NUMBER(20) 查询级别标志:1班级,2年级,3学校


新版宿舍考勤按宿舍统计表(当天早寝开门以后)
T_KQDORM_BYDORM_NEW

  LOGDATE DATE not null 统计日期,
  SCHOOL_ID NUMBER(19) 学校id,
  SCHOOL_NAME VARCHAR2(50) 学校名称 + 合计,
  FLOOR_ID NUMBER(19) 宿舍楼id,
  FLOOR_NAME VARCHAR2(50) 宿舍楼名称 + 小计,
  LAYER_ID NUMBER(19) 楼层id,
  LAYER_NAME VARCHAR2(50) 楼层名称 + 小计,
  DORM_ID NUMBER(19) 宿舍id,
  DORM_NAME VARCHAR2(50) 宿舍名称 + 小计,
  STU_CNT NUMBER(20) 学生总数,
  ZO_MS_CARD_IN_NUM NUMBER(20) 凌晨0点到明晨早寝出寑开门时段进人数,
  ZO_MS_CARD_OUT_NUM NUMBER(20) 凌晨0点到明晨早寝出寑开门时段出人数,
  MS_CARD_IN_NUM NUMBER(20) 早寝开门到关门时段进人数,
  MS_CARD_OUT_NUM NUMBER(20) 早寝开门到关门时段出人数,
  MS_CARD_NOCARD_NUM NUMBER(20) 早寝开门到关门时段未刷卡人数,
  MS_ZIS_CARD_IN_NUM NUMBER(20) 早寝出寑关门到中午入侵时段进人数,
  MS_ZIS_CARD_OUT_NUM NUMBER(20) 早寝出寑关门到中午入侵时段出人数,
  ZIS_CARD_IN_NUM NUMBER(20) 中午入寝开门到关门时段进人数,
  ZIS_CARD_OUT_NUM NUMBER(20) 中午入寝开门到关门时段出人数,
  ZIS_CARD_NOCARD_NUM NUMBER(20) 中午入寝开门到关门时段未刷卡人数,
  ZIS_ZOS_CARD_IN_NUM NUMBER(20) 中午入侵关门到中午出寑开门时段进人数,
  ZIS_ZOS_CARD_OUT_NUM NUMBER(20) 中午入侵关门到中午出寑开门时段出人数,
  ZOS_CARD_IN_NUM NUMBER(20) 中午出寝开门到关门时段进人数,
  ZOS_CARD_OUT_NUM NUMBER(20) 中午出寝开门到关门时段出人数,
  ZOS_CARD_NOCARD_NUM NUMBER(20) 中午出寝开门到关门时段未刷卡人数,
  ZOS_NS_CARD_IN_NUM NUMBER(20) 中午出寝关门到晚寝入侵开门时段进人数,
  ZOS_NS_CARD_OUT_NUM NUMBER(20) 中午出寝关门到晚寝入侵开门时段出人数,
  NS_CARD_IN_NUM NUMBER(20) 晚寝入侵开门到关门时段进人数,
  NS_CARD_OUT_NUM NUMBER(20) 晚寝入侵开门到关门时段出人数,
  NS_CARD_NOCARD_NUM NUMBER(20) 晚寝入侵开门到关门时段未刷卡人数,
  NS_ZO_CARD_IN_NUM NUMBER(20) 晚寝入侵关门到凌晨0点时段进人数,
  NS_ZO_CARD_OUT_NUM NUMBER(20) 晚寝入侵关门到凌晨0点时段出人数,
  MARK NUMBER(20) 查询级别标志:1宿舍,2楼层,3宿舍楼,4学校


刷卡签到记录表6
T_CARD_SIGNIN_RECORD6

  ID NUMBER(19) not null constraint PK_T_CARD_SIGNIN_RECORD6 primary key,
  SCHOOL_ID NUMBER(19) 学校ID,
  TERMINAL_TYPE VARCHAR2(10) 终端类型,
  TERMINAL_NUM VARCHAR2(15) 终端编号,
  CARD_NUM VARCHAR2(15) 卡内码号,
  CARD_TIME DATE 刷卡时间,
  DIRECTION NUMBER(1) 0出,
  SAVE_TIME DATE 存储时间,
  TERMINAL_TYPE_ID NUMBER(19) 短信模板ID,
  THERMOMETER FLOAT 体温


刷卡签到记录历史表
T_CARD_SIGNIN_RECORD_HIS

  ID NUMBER(19) not null,
  SCHOOLID NUMBER(19) 学校ID,
  TERMINALTYPE VARCHAR2(10) 终端类型,
  TERMINALNUM VARCHAR2(15) 终端编号,
  CARDNUM VARCHAR2(15) 卡内码号,
  CARDTIME DATE 刷卡时间,
  DIRECTION NUMBER(1) 0出,
  SAVETIME DATE 存储时间,
  STUDENT_ID NUMBER(19) default 0 学生id,
  TERMINAL_TYPE_ID NUMBER(19) 短信模板ID,
  THERMOMETER FLOAT 体温


床位表
T_BED

	ID NUMBER(19) not null primary key,
	ALLOT NUMBER(1) default 0 0未分配，可分配，1分配了,
	BED_NAME VARCHAR2(30 char),
	DORM_ID NUMBER(19) constraint FK68F52361C99714A references T_DORM,
	STUDENT_ID NUMBER(19) constraint FK68F5236530AFAB0 references T_STUDENT 分配的学生ID，学生ID为空，allot一定为0,
	ISACTIVE NUMBER(10) default 1


------------ 成绩管理

考试分数表
T_SCORE

  ID NUMBER(19) not null
    primary key,
  EXAM_NAME VARCHAR2(12 char),
  EXAM_STREAM VARCHAR2(10 char),
  EXAM_TIME VARCHAR2(10 char),
  EXAM_TYPE NUMBER(10),
  ISACTIVE NUMBER(10),
  SCHOOL_ID NUMBER(19),
  SCORE NUMBER(5,2) default 0,
  SUBJECT_ID NUMBER(19)
    constraint FKA0F27B07AC279050
      references T_SUBJECT,
  CLASS_ID NUMBER(19)
    constraint FKA0F27B07B36EDC90
      references T_CLASS,
  STUDENT_ID NUMBER(19)
    constraint FKA0F27B07530AFAB0
      references T_STUDENT


考试科目字典表
T_SCORE_COURSE

  ID VARCHAR2(64) not null
    primary key, 主键
  NAME VARCHAR2(50), 课程名称
  SCHOOL_ID VARCHAR2(64), 学校ID
  SHOW_FLAG NUMBER(1), 0 不显示  1 显示
  EXCELLENT_SCORE NUMBER(5,2), 优秀的成绩线
  PASS_SCORE NUMBER(5,2), 及格的成绩线
  TOTAL_SCORE NUMBER(5,2), 满分
  CREATE_BY VARCHAR2(64) not null, 创建者
  CREATE_DATE TIMESTAMP(6) default sysdate not null, 创建时间
  UPDATE_BY VARCHAR2(64), 更新者
  UPDATE_DATE TIMESTAMP(6), 更新时间
  DEL_FLAG NUMBER(1) default 0 not null, 删除标记 0 未删除  1 已删除
  RELATION_COURSE_ID VARCHAR2(64), 映射的科目ID（备用）
  IS_PUBLIC NUMBER(1) not null 1代表公共课程 所有学校都有 0代表 只属于本学校的


考试记录表
T_SCORE_EXAM

  ID VARCHAR2(64) not null
    constraint PK_T_SCORE_EXAM
      primary key, 主键
  NAME VARCHAR2(255), 考试单名称
  SCHOOL_ID VARCHAR2(64), 学校ID
  EXAM_TYPE NUMBER(1), 考试类别(1 期末考试, 2期中考试, 3 月考考试 , 4单元测试考试, 5单元模拟考试, 6 其他 )
  START_TIME TIMESTAMP(6), 考试开始时间
  END_TIME TIMESTAMP(6), 考试结束时间
  EXAM_SCOPE NUMBER(1), 考试范围(1年级  2 班级)
  CREATE_BY VARCHAR2(64), 创建者ID
  CREATE_DATE TIMESTAMP(6), 创建时间
  UPDATE_BY VARCHAR2(64), 更新者ID
  UPDATE_DATE TIMESTAMP(6), 更新时间
  DEL_FLAG NUMBER(1), 删除标记
  CLASS_ID VARCHAR2(64), 班级ID
  GRADE_ID VARCHAR2(64), 年级ID
  UNION_ID VARCHAR2(64), 同一次考试 唯一标识
  EXAM_TERM VARCHAR2(30) 考试学年


考试详情表
T_SCORE_EXAM_DETAIL

  ID VARCHAR2(64) not null
    primary key, 主键
  EXAM_ID VARCHAR2(64) not null, 考试单id
  SCHOOL_ID VARCHAR2(64) not null, 学校ID
  GRADE_ID VARCHAR2(64) not null, 年级ID
  CLASS_ID VARCHAR2(64) not null, 班级ID
  STUDENT_ID VARCHAR2(64) not null, 学生ID
  COURSE_ID VARCHAR2(64) not null, 课程ID
  SCORE NUMBER(6,2), 成绩分数
  SCORE_TYPE NUMBER(1), 成绩类别(1 优秀 2 良好 3 及格 4 不及格)
  SCORE_DEGREE VARCHAR2(255), 成绩评价(A B C D )
  CLASS_ORDER NUMBER(5), 班级排名
  GRADE_ORDER NUMBER(5), 年级排名
  CREATE_BY VARCHAR2(64) not null, 创建者ID
  CREATE_DATE TIMESTAMP(6) not null, 创建时间
  UPDATE_BY VARCHAR2(64), 更新者ID
  UPDATE_DATE TIMESTAMP(6), 更新时间
  DEL_FLAG NUMBER(1) default 0 not null, 删除标记 0不删除 1 删除
  READ_TYPE NUMBER(1) default 0, 默认为0,   1表示已读,0表示未读
  GRADE_NAME VARCHAR2(64), 年级名字
  CLASS_NAME VARCHAR2(64), 班级名字
  STUDENT_NAME VARCHAR2(64) 学生名字


成绩类型定义中间表
T_SCORE_EXAM_EXCELLENT

  ID VARCHAR2(64) not null
    primary key, 主键
  EXAM_ID VARCHAR2(64) not null, 考试ID
  COURSE_ID VARCHAR2(64) not null, 课程ID
  PASS_SCORE NUMBER(5,2), 及格分数线
  EXCELLENT_SCORE NUMBER(5,2), 优秀分数线
  SCORE_TYPE NUMBER(1) not null, 成绩类型(1是分数 2是ABCD 3 是优良中差)
  AVG_SCORE NUMBER(6,2), 平均分（成绩类型为1时有值，否则为空）
  HIGH_SCORE NUMBER(6,2), 此次考试班级最高分（成绩类型为1时有值，否则为空）
  LOW_SCORE NUMBER(6,2), 此次考试班级最低分（成绩类型为1时有值，否则为空）
  PASS_SCALE VARCHAR2(64), 及格率
  FINE_SCALE VARCHAR2(64), 优秀率
  CLASS_STCOUNT NUMBER(5), 班级人数
  LACK_STCOUNT NUMBER(5) 缺考人数



------------ 积分库表

积分账户
T_JF_ACCOUNT

ABB_CODE  对应T_TEACHER表中id 6位及6位以下为真实存在的教师 学校主管理员账号是9999+0000+学校ID



T_JF_BUSINESS_DETAILS
账务明细


积分计算月度充值明细
T_JF_MONTHLY_RECHARGE (没有mobile)


学校积分配置表
T_SCHOOL_SET



积分人工数据表，由过程批量导入
T_JF_TMP_ART



----------------- 通知相关


通知模板类型表
T_APP_TEMPLATE_TYPE

  ID VARCHAR2(20) not null constraint PK_T_APP_TEMPLATE_TYPE primary key 类型id, 
  FATHER_ID VARCHAR2(20) 父id,
  ISLEAF NUMBER(1) 是否为子:1是0否,
  TYPE_NAME VARCHAR2(50 char) 类型名称,
  SCHOOL_TYPE NUMBER(1) 学段:0通用，1幼儿园，2小学，3中学，4高中,
  ISACTIVE NUMBER(1) 是否删除
 

通知模板表
T_APP_TEMPLATE

  ID NUMBER(19) not null constraint PK_T_APP_TEMPLATE primary key,
  TEMPLATE_CONTENT VARCHAR2(360 char) 模板内容,
  TYPE_ID VARCHAR2(20) 模板类型id,
  TEMPLATE_TITLE VARCHAR2(50 char) 模板标题,
  ISACTIVE NUMBER(1) 是否删除,
  ISRECOMMEND NUMBER(1) 是否推荐:0未推荐,1 推荐,
  RECOMMEND_TIME DATE 推荐时间,
  ADD_TIME DATE 添加时间,
  USE_FREQUENCE NUMBER(19) default 0 使用频度


青于蓝小纸条内容表
T_QYL_NOTE


青于蓝定时消息存储表
T_QYL_MESSAGE_TIMER


家校互动——消息内容表
T_MESSAGE_CONTENT

  MESSAGE_ID NUMBER(19) not null primary key 信息id,
  CONTENT VARCHAR2(4000 char) 信息内容,
  MESSAGE_TYPE VARCHAR2(2 char) 信息类型1:通知2:作业3:聊天4:成绩6:作文,
  IS_ACTIVE VARCHAR2(2 char) default 1 是否有效0:无效1:有效,
  MESSAGE_TITLE VARCHAR2(100 char) 消息标题,
  IMAGE1_URL VARCHAR2(1024 char) 图片1 url,
  IMAGE2_URL VARCHAR2(1024 char) 图片2 url,
  IMAGE3_URL VARCHAR2(1024 char) 图片3 url,
  AUDIO_URL VARCHAR2(1024 char) 音频 url,
  COURSE_ID NUMBER(5) 作业对应的课程id,消息类型为通知时该字段存空,
  ISAPP NUMBER(1) 是否通过app端发送1:是0:否,
  MESSAGE_TO VARCHAR2(1024 char) 消息发送对象,全年级显示年级名称,
  UUID VARCHAR2(100 char) 发送消息时附带的唯一标识符，由客户端提供,
  IMAGE_URLS VARCHAR2(1024 char) 图片地址,以逗号分割,
  DEADLINE TIMESTAMP(6) 作文截止时间,
  MIN_WORD_NUM NUMBER(5) default 0 最小字数限制,
  SCORE_SYSTEM NUMBER(1) default 1 分制 0:60分 1:100分


消息流水表
T_MESSAGE_NOW

  ID NUMBER(19) not null primary key ,
  SENDER_ID NUMBER(19) 发送人id,
  SENDER_TYPE VARCHAR2(100 char) 发送人角色类型,
  DEST_ID NUMBER(19) 接收人id，老师ID或者学生ID,
  DEST_TYPE VARCHAR2(2 char) 接收人类型1:老师2:学生,
  SEND_TIME TIMESTAMP(6) 发送时间,
  PC_FLAG VARCHAR2(2 char) default 0 pc端是否已读,
  PC_TIME TIMESTAMP(6) pc端阅览时间,
  APP_FLAG VARCHAR2(2 char) default 0 app是否已读0未读，1已读,
  APP_TIME TIMESTAMP(6) app阅览时间,
  MESSAGE_ID NUMBER(19) not null 消息id,
  SENDER_NAME VARCHAR2(30 char) 发送人姓名,
  DEST_NAME VARCHAR2(30 char) 接收人姓名,
  IS_SEND_ACTIVE VARCHAR2(2 char) default 1 对发送人是否有效0:无效1:有效,
  IS_RECEIVE_ACTIVE VARCHAR2(2 char) default 1 对接收人是否有效0:无效1:有效,
  SURE_FLAG VARCHAR2(2 char) default 0 APP端是否确定 0是未确认，1是已确认,
  CLASS_NAME VARCHAR2(30) 学生所在班级名字,
  CLASS_ID NUMBER 班级id,
  APP_COLLECTION VARCHAR2(2) default 0 是否收藏,
  QUESTION_ID NUMBER ,
  SCORE VARCHAR2(12) default 0,
  IS_COMPLETE NUMBER default 0 ,
  ZUOWEN_GRADE NUMBER(2),
  ZUOWEN_ID NUMBER(19) MySQL作文表id,
  SMS_PORT NUMBER(19) 短信端口(关联回复短信使用),
  STATUS NUMBER(1) default 0 状态0正常1删除,
  IS_READ NUMBER(1) （作文是否已读）0 未读  1 已读


消息教师表
T_QYL_TEACHER_NOTICE_CACHE

  ID NUMBER(19) not null constraint SYS_C0056553 primary key,
  MESSAGE_TYPE NUMBER(1) 信息类型1:通知2:作业3:聊天4:成绩5:请假6:作文,9:素材征集,
  MESSAGE_TITLE VARCHAR2(128) 标题,
  MESSAGE_CONTENT VARCHAR2(4000) 内容,
  MESSAGE_IMG_URL VARCHAR2(1024) 图片,
  CREATE_TIME TIMESTAMP(6) 添加时间,
  USER_ID NUMBER(19) 教师id,
  BIZ_ID NUMBER(19) 业务id,
  SENDER_ID NUMBER(19) 发送人id,
  STATE NUMBER(1) default 0 状态(0:未读,1:已读),
  CLASS_NAME VARCHAR2(255) 班级名称,
  SCHOOL_NAME VARCHAR2(255) 学校名称,
  SENDER VARCHAR2(255) 发送人,
  EXAM_TIME TIMESTAMP(6) 考试结束时间,
  EXAM_TYPE NUMBER(1) 考试类别(1 期末考试, 2期中考试, 3 月考考试 , 4单元测试考试, 5单元模拟考试, 6 其他 ),
  EXAM_ID VARCHAR2(64) 考试单id,
  EXAM_NAME VARCHAR2(255) 考试单名称,
  CLASS_ID NUMBER(19) 班级id,
  IS_CONLLECTION VARCHAR2(2) APP端是否收藏0未收藏1已收藏


通知家长表
T_QYL_NOTICE_CACHE

  ID NUMBER(19) not null 主键,
  NOTICE_TYPE NUMBER(1) 通知类型(0:通知,1:作业,2:作文,3:成绩,4:请假,5:消费,6:领款,7:充值,8:余额,9:素材征集),
  NOTICE_TITLE VARCHAR2(128) 通知标题,
  NOTICE_CONTENT VARCHAR2(4000 char) 通知内容,
  NOTICE_IMG_URL VARCHAR2(1024 char) 通知图片URL,
  CREATE_TIME TIMESTAMP(6) 创建时间,
  USER_ID NUMBER(19) 学生用户ID,
  BIZ_ID NUMBER(19) 业务ID,
  STATE NUMBER(1) 状态(0:未读,1:已读),
  SENDER VARCHAR2(20) 发送人,
  DEADLINE TIMESTAMP(6) 布置作文截止时间


附图文表
T_QYL_ARTICLE

  ID NUMBER(19) not null constraint ARTICLEID primary key,
  GROUP_ID NUMBER(19) 主图文ID,
  GPIC_URL VARCHAR2(300) 附图所在七牛云url,
  GTITLE VARCHAR2(300) 附图表题--这个夏天...,
  ARTICLE CLOB 文章富文本,
  CREATE_TIME TIMESTAMP(6) 创建时间,
  TAG_ID NUMBER(19) 文章标签ID,
  AUTHOR VARCHAR2(70) 作者,
  PRIORITY VARCHAR2(5) 优先级,
  TAG_NAME VARCHAR2(70) 标签名字,
  AUTHOR_ID NUMBER(19) 编辑人ID,
  FLAG VARCHAR2(10) 图文类型，1：系统广告，2，云校刊，3，云板报，4，叶超占位，5，作文大赛，6，小记者，7，安全教育刊物，8，单篇文章（特辑）,
  READ_NUM NUMBER(19) default 0 文章阅读量(虚)（4）,
  PRAISE_NUM NUMBER(19) default 0 点赞数量（4）,
  READ_NUM_TRUE NUMBER(19) default 0 文章阅读量(实)（4）


主图文表
T_QYL_ARTICLE_GROUP

  ID NUMBER(19) not null,
  ATITLE VARCHAR2(200) 主图标题--师说 | 如何过一个有意义的暑假？,
  EXPLAIN VARCHAR2(300) 主图说明--第二期  我的暑假",
  CREATE_TIME TIMESTAMP(6) 创建时间,
  FLAG VARCHAR2(10) 图文类型，1：系统刊物（青于蓝刊物）, 2云校刊, 3云板报, 4叶超占位, 5作文大赛, 6小记者, 7安全教育刊物, 8单篇文章（特辑） 9作文提分,
  SCHOOL_ID NUMBER(19) 学校id,
  SCHOOL_NAME VARCHAR2(50) 学校名字,
  CLASS_ID NUMBER(19) 班级id ,
  CLASS_NAME VARCHAR2(50) 班级名字,
  STATE VARCHAR2(50) 图文状态0未发布，1发布了, 2发布中,
  AUTHOR VARCHAR2(50) 作者,
  APIC_URL VARCHAR2(200) 七牛云url,
  TARGET_ROLE VARCHAR2(10) 2全部，0教师，1家长（3）,
  SCHOOL_TYPE_ID NUMBER(19) 189幼儿园，190小学，191初中，192高中，193复合，194其他，0全部（3）,
  SEND_TIME TIMESTAMP(6) 定时发送时间,
  READ_NUM NUMBER(19) default 0 文章阅读量（4）,
  PRAISE_NUM NUMBER(19) default 0 点赞数量（4）,
  COLLECT_NUM NUMBER(19) default 0 收藏数量（4）,
  READ_NUM_TRUE NUMBER(19) default 0 文章阅读量(实)（4）


家长端素材表
T_QYL_MATERIAL

    ID NUMBER(19) not null ,
    MATERIAL_TITLE  VARCHAR2(15) 素材标题,
    MATERIAL_CONTENT  CLOB 素材内容,
    CLASS_ID     NUMBER(19) 班级id,
    STUDENT_ID   NUMBER(19) 学生id,
    OPER_ID	 NUMBER(19) 操作人id,
    VIDEO_URL    VARCHAR2(255) 视频URL,
    PICTURE_URL  VARCHAR(1000) 图片URL最多9个,
    CREATE_TIME  DATE 创建时间,
    UPDATE_TIME  DATE 修改时间,
    STATE             NUMBER(1) 是否选中 1:已选中 0:未选中,
    MESSAGE_NOW_ID    NUMBER(19) MESSAGE_NOW主键id
    PRIORITY    NUMBER(5) 被选中优先序


评论表
T_QYL_ARTICLE_COMMENT

  ID          NUMBER not null,
  PARENT_ID   NUMBER 家长ID,
  COMMENTS    VARCHAR2(500) 评论内容,
  CREATE_TIME TIMESTAMP(6) 评论时间,
  ARTICLE_ID  NUMBER(19) 附文章ID,
  REPLY_ID    NUMBER default 0 被回复的评论ID,
  TEACHER_ID  NUMBER 老师ID


附文章评论点赞表
T_QYL_ARTICLE_COMMENT_UP

  ID          NUMBER(19) not null constraint ACOMUPID  primary key,
  COMMENT_ID  NUMBER(19) 家长评论表或者老师评论表ID,
  USER_ID     NUMBER(19) 评论用户ID 如果是老师，此字段就是老师ID，如果是家长，就是家长ID,
  CREATE_TIME TIMESTAMP(6) 最后点赞时间,
  ROLE        VARCHAR2(10) 角色ID  0:老师,1:家长


-----------------流程 & 实例相关

请假流程表
T_PROCESS_TASK

  ID NUMBER(19) not null constraint T_PROCESS_TASK_ID primary key,
  PROCESS_INSTANCE_ID NUMBER(19) 流程实例ID,
  APPROVER NUMBER(19) 审批人,
  APPROVAL_OPINIONS VARCHAR2(100) 审批意见,
  SCHOOL_ID NUMBER(19) 学校ID,
  SEQ NUMBER(2) 序号,
  STATE CHAR 是否该本人审批  0:否 1:审批中 2:已通过3:已拒绝,
  REST_ID NUMBER(19) 请假ID,
  ISAUDITPERSON CHAR 1:是 0:不是(是否是发起人),
  APPROVER_NAME VARCHAR2(20) 审批人角色,
  UPDATE_TIME DATE 更新时间



流程实例表
t_process_instance


流程定义表
t_process_define


-----------------点名

老师查寝记录表
T_TEACHER_CQ_RECORD

  ID NUMBER(19) not null constraint PK_T_TEACHER_CQ_RECORD primary key,
  FLOOR_ID NUMBER(19) 宿舍楼ID,
  LAYER_ID NUMBER(19) 楼层ID,
  DORM_ID NUMBER(19) 宿舍ID,
  TEACHER_ID NUMBER(19) 老师id,
  CREATE_TIME DATE 创建时间,
  ISACTIVE NUMBER(1) 是否有效,
  MEMO VARCHAR2(20)


学生查寝记录表
T_STUDENT_CQ_RECORD

  ID NUMBER(19) not null constraint PK_T_STUDENT_CQ_RECORD primary key,
  STUDENT_ID NUMBER(19) 学生ID,
  BED_ID NUMBER(19) 床位ID,
  DORM_ID NUMBER(19) 宿舍ID,
  LAYER_ID NUMBER(19) 楼层ID,
  FLOOR_ID NUMBER(19) 宿舍楼ID,
  STATE NUMBER(1) 查寝状态（1正常，2请假，3未到）,
  CREATE_TIME DATE 创建时间,
  T_TEACHER_CQ_ID NUMBER(19) constraint FK_T_STUDEN_TEACHERCQ_T_TEACHE references T_TEACHER_CQ_RECORD 老师查寝记录表ID,
  MEMO VARCHAR2(20) 


教师点名记录表
T_TEACHER_DM

  ID NUMBER(19) not null primary key ,
  TEACHER_ID NUMBER(19) 教师ID,
  CLASS_ID NUMBER(19) 班级ID,
  CREATE_TIME DATE 创建时间,
  ISACTIVE NUMBER(1) 是否有效（0无效，1有效）,
  IS_SEND NUMBER(1) 是否发送过短信（1已发送过短信）,
  LESSONS NUMBER(5) 第几节课,
  UPDATE_TIME DATE 更新日期,
  PLATFORM NUMBER(1) default 0


学生点名记录表
T_STUDENT_DM

  ID NUMBER(19) not null primary key,
  STUDENT_ID NUMBER(19) 学生ID,
  CLASS_ID NUMBER(19) 班级ID,
  STATE NUMBER(1) 状态（1正常，2请假，3未到）,
  CREATE_TIME DATE 创建时间,
  T_TEACHER_DM_ID NUMBER(19) 教师点名表ID,
  LESSONS NUMBER(5) 第几节课,
  LESSONS_TXT VARCHAR2(50) default null 点名节次文本内容,
  PLATFORM NUMBER(1) default 0 


-----------------手机品牌

青于蓝手机设置表
T_QYL_PHONE_SETTING

  ID NUMBER(19) not null 主键，SEQ_T_QYL_PHONE_SETTING序列,
  PHONE_BRAND VARCHAR2(32) 手机品牌,
  PHONE_MODEL VARCHAR2(50) 手机型号,
  OS_VERSION VARCHAR2(32) 手机操作系统版本号,
  VP_GUIDE_URL VARCHAR2(500) 可视电话引导图片URL,
  CREATE_TIME TIMESTAMP(6) 创建时间,
  UPDATE_TIME TIMESTAMP(6) 更新时间





