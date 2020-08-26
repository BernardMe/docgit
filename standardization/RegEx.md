    

# 正则表达式



## Java代码实现

```java
public class RegExTest { 

private static String regEx = "^(20|19)[0-9][0-9]-(0[1-9]|1[012])$";

private static String regEx = "^("
			+"((20|19)[0-9][0-9]-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|"
			+"((20|19)(0[48]|[2468][048]|[13579][26])|2000-02-29))\\s+([0-1]?[0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])$";

public static void isEmail(String text) {
        String regex = "^([a-z0-9A-Z]+[-|_|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";
        pattern(text, regex, true, getMessage("EMAIL_ILLEGAL"));


public static void isMobile(String text) {
        String regex = "((^(13|14|15|16|17|18|19)[0-9]{9}$)|(^0[1,2]{1}\\d{1}-?\\d{8}$)|(^0[3-9] {1}\\d{2}-?\\d{7,8}$)|(^0[1,2]{1}\\d{1}-?\\d{8}-(\\d{1,4})$)|(^0[3-9]{1}\\d{2}-? \\d{7,8}-(\\d{1,4})$))";
        pattern(text, regex, true, "手机号格式错误！");
}
```


