---
title: 设计模式-代理【Proxy】
date: 2018-09-01 11:24:59
type: "categories"
categories: 设计模式
tags: 设计模式
---
![](img/index-page-img/设计模式.png)

代理设计模式，代理目标，代替直接操作目标对象。

<!-- more -->


### 介绍

代理设计模式，在日常开发中，还是很常用的。主要是代理一个类的方法，在代理类做一些其他的逻辑。也可以说是为目标类分担一部分工作。


### UML

![](img/设计模式-代理【Proxy】/UML.png)

### 方法说明

* Client:调用方，调用目标的方法的类。
* Subject:主体，目标类和代理对象的实现的接口，为**Proxy**和**RealSubject**定义一致性接口。
* Proxy:代理对象，**持有目标类的对象实例**，通过调用**proxy**持有的目标类对象间接调用**RealSubject**中的方法，在代理方法中做一些其他的逻辑，或者分担一些目标方法的任务。
* RealSubject:真正调用被调用，被代理的对象。


### Spring 中的两种代理方式

spring的aop就是通过代理的方式实现方法的织入的，aop的实现方式有两种：

* jdk原生代理：jdk原生包中提供的功能。原生代理只能代理**接口**的实现类，通过反射的方式调用。
* cglib代理：第三方的代理方式，这是一个生成代码的工具包，主要是通过**继承**的方式，**生成**目标对象的子类，从而代理目标方法，通过继承的方式实现。所以因为通过**继承**的方式实现，也就不能使用代理**final class**，其他的类都是能通过这种方式代理。


**源码地址**：
<a>https://github.com/wangypeng/java-design-mode-source/tree/master/proxy</a>