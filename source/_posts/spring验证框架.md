---
title: spring验证框架
date: 2018-10-02 21:55:17
type: "categories"
categories: spring
tags: spring

---

![](img/index-page-img/spring.jpg)

基础标准JSR-303规范验证框架@Valid和@Validated,风骚的操作

<!-- more -->

### 为什么要引入验证框架

日常开发中，在Controller中校验参数，可能是日常编码编码中比较烦的一件事，大段的验证代码，没有任何业务意义，在参数校验较多的时候，会导致controller方法非常的臃肿，并且也不好维护，需要大量的注释维护语义。这可能是我开发中的一个痛点了。但是在后来，接触到了Validation框架，真的是击中了我的痛点，所以详细的整理了一下。写了这篇文章。

### 介绍

java很早就有了标准JSR-303，javax提供了@Valid（标准JSR-303规范），Spring Validation验证框架对参数的验证机制提供了@Validated（Spring’s JSR-303规范，是标准JSR-303的一个变种）。

### API

#### 对象验证

##### bean中增加验证标签

| 标签                 |   功能            |
|:-------------------:|:------------------:|
| @Null         |            限制只能为null        |
| @NotNull       |      限制必须不为null              |
| @AssertFalse     |    限制必须为false                |
| @AssertTrue             |   限制必须为true      |
| @DecimalMax(value)   | 限制必须为一个不大于指定值的数字       |
| @DecimalMin(value)       |  限制必须为一个不小于指定值的数字           |
| @Digits(integer,fraction) |  限制必须为一个小数，且整数部分的位数不能超过integer，小数部 分的位数不能超过fraction    |
| @Future       |        限制必须是一个将来的日期        |
| @Max(value)      |    限制必须为一个不大于指定值的数字            |
| @Min(value)	   |   限制必须为一个不小于指定值的数字            |
| @Pattern(value)         |   限制必须符合指定的正则表达式      |
| @Size(max,min)  | 限制字符长度必须在min到max之间   |
| @NotEmpty     |  验证注解的元素值不为null且不为空（字符串长度不为0、集合大小不 为0）          |
|@NotBlank |验证注解的元素值不为空（不为null、去除首位空格后长度为0） ,不同于@NotEmpty ，@NotBlank只应用于字符串且在比较时会去除字符串的空格|
|@Email	|验证注解的元素值是Email，也可以通过正则表达式和flag指定自定 义的email格式|

##### 分组
上述注解标签都支持，group属性，新写一个接口类，在填写注解接口类型

##### 嵌套

在日常开发中，会碰到嵌套对象的情况，嵌套对象的需要验证，可以在验证的域上增加@Valid，当且仅当只有@Valid支持对象嵌套验证。

##### 补充其他功能注解


* @DateTimeFormat(pattern=”yyyy-MM-ddHH:mm:ss”) 时间格式标签
* @JsonFormat(pattern=”yyyy-MM-ddHH:mm:ss”) json格式化标签

##### 使用

Controller方法参数签字中对象，增加@Validated/@Valid，在方法上最好使用 @Validated，这个注解支持分组验证。

##### 单个签字域校验

需要使用@Validated，这个注解支持类验证，即可对单个域进行验证。

##### 自定义注解及处理器

demo:

{% codeblock %}

@Target({ElementType.TYPE, ElementType.METHOD, ElementType.FIELD, ElementType.ANNOTATION_TYPE, ElementType.CONSTRUCTOR, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Constraint(validatedBy = {EmailValidator.class})
public @interface ValidEmail {
    boolean required() default true;
    String message() default "邮箱不合法";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}

{% endcodeblock %}

描述：@Constraint(validatedBy = {EmailValidator.class}) 通过这个注解定义它的处理验证器

{% codeblock %}

public class EmailValidator implements ConstraintValidator<ValidEmail, String> {
    private boolean required = false;
    //初始化方法
    @Override
    public void initialize(ValidEmail constraintAnnotation) {
        required = constraintAnnotation.required();
    }
    //校验方法
    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
    		doSomething();
    }
}

{% endcodeblock %}


描述：ConstraintValidator 实现接口重写方法


##### 定义消息体

必须指定这个路径和文件名：resource/ValidationMessages.properties
文件的编码为ASCII

### 验证异常处理

两种：

* 方法中增加BindException
* 定义全局异常处理器，单域验证ConstraintViolationException，对象验证BindException，resquestBody对象验证MethodArgumentNotValidException


### ide验证

![](img/ide空验证.png)

配置使用**@NotNull**和**@Nullable**注解，通过上下文进行校验。


#### 源码地址:
<a>https://github.com/wangypeng/spring-boot-validator</a>