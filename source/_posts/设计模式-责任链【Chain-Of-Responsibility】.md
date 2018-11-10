---
title: 设计模式-责任链【Chain Of Responsibility】
date: 2018-11-10 11:24:14
type: "categories"
categories: 设计模式
tags: 设计模式
---

![](img/index-page-img/设计模式.png)

责任链，将多个对象组合成一条责任链，对逻辑进行链式处理。

<!-- more -->

### 介绍
责任链设计模式，在web开发中，使用可能比较少，但是应用还是比较多，比如，拦截器的实现，过滤器，tomcat 处理请求，mybatis的拦截器。应用的例子很多。这也是一个比较重要的设计模式。

### UML

![](img/设计模式-责任链【Chain Of Responsibility】/UML.png)


### 使用说明

* clent:调用方Handler.excute()。调用整个执行链
* Handler:责任链上的对象的接口类,定义责任链上的类的接口。	
	1. setNext(Handler)：设置责任链上下处理业务handler		
	2. excute()：对外报漏的执行方法，触发执行整个责任链。整个链的执行逻辑方法，执行下个节点还是返回。			
	3. abstract process():抽象方法，业务子类实现该方法，每个业务处理单元实现业务方法
* AHandler:实现handler抽象process方法，业务处理方法
* BHandler:实现handler抽象process方法，业务处理方法，还有一些私有的方法。

### 应用

在很多地方都有应用，在tomcat处理请求的时候，对request的处理就使用了责任链的设计模式对，请求惊醒处理，先处理过滤器逻辑，在处理拦截器，在根据url的mapping映射到对应的业务逻辑处理Controller。在做mybatis插件的时候，他的拦截器也是使用的责任的设计模式。

### 优点

举个例子，就拿request请求来说，到达服务的时候，可能对url很多不同的处理，全部的逻辑在一个方法里，或者是一个类，这样，方法，类的职业，并不单一，并且全部耦合在一起，一旦逻辑复杂维护成高会非常高。

使用责任链设计模式，就弱化了请求方和处理方的关联关系，很好的解耦，每一个组件都可以成为一个独立服用的组件，并且可以通过组合的方式，可以处理流程更加灵活。逻辑性更加清晰，可以使用配置的方式，组合不同责任链组件，维护成本也会大大减低。

### 源地址
<a>https://github.com/wangypeng/java-design-mode-source/tree/master/chain-of-responsibility</a>

