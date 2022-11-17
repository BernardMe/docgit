

## iBatis与MyBatis区别

一、最主要的区别就是mybatis简化了编码的过程,不需要去写dao的实现类，直接写一个dao的借口,再写一个xml配置文件,整个mybatis就配置好了,也就是数据库就连接好了,然后再service里面调用dao就可以了,但是ibatis则不可以,必须要写dao的实现类,在写个什么return getSqlMapClientTemplate ().queryForList ()神马的,还有些区别就是xml里面的sql语句的写法有些小变化,但是不大
二、 Mybatis实现了接口绑定，使用更加方便。



## iBatis问题搜集 

ibatis在动态列查询时，出现列名无效错误（使用remapResults属性）
当SQL语句是查询的数据项列是动态的，需要使用remapResults属性，并将其设置为true。
出现错误如下：
com.ibatis.common.jdbc.exception.NestedSQLException:
— The error occurred in com/ictehi/grainplat/sqlMap/sainout.xml.
— The error occurred while applying a result map.
— Check the findSaInOutByPinzhong-AutoResultMap.
— Check the result mapping for the ‘countyid’ property.
— Cause: java.sql.SQLException: 列名无效

如：
```xml
<select id="xxxxxxxxxx" parameterClass="map" resultMap="baseResultMap" remapResults="true">
    SELECT $field$
    FROM dual
    WHERE xxxx = xx
</select>
```

如：使用动态标签（）等等

像这种，select后面查询数据列是动态的，需要设置remapResults为ture
为啥呢？因为ibatis默认的会缓存rs中的meta信息，如果你第一次查询的列和第二次查询的列不一样的话，那么第二次ibatis还会以第一次查询的列为key从rs里面获取数据，但是第二次列已经变化了，所以第二次取数据的时候，RS里面已经没有了你第一次的那个列了，所以会出错


