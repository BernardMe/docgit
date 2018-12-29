


## 关联关系




### 多对多

`一个访客预约可以下发给一个权限组，一个权限组可以接收多个访客预约`

权限组  1 - 下发 - N  访客预约

`对于多对多关系中，在一个表中添加一个字段就行不通了
所以处理多对多关系问题时，就要考虑建立关系表了`


设备  M - 管理 - N  权限组


访客登记表visitor_register_info
permissionsetId     权限组id


建立中间表visitor_permissionsetDevice
id
permissionsetId
deviceId
memo
domainId

权限组表visitor_permissionset
id
name
createTime
modifyTime
departmentId
domainId



