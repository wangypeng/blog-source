---
title: 设计模式-组合【Composite】
date: 2018-08-18 18:23:40
type: "categories"
categories: 设计模式
tags: 设计模式
---

![](img/index-page-img/设计模式.png)

组合状态模式，递归组合目标数据结构。

<!-- more -->

### 介绍

**组合设计模式**，主要是使用容器和内容具有一致性，并使用这种一致性，去创建**递归的数据结构**。


### 应用场景

根据的结构设计模式的特点：递归的数据机构。可以构建，**树**，**文件夹**，这种迭代的数据结构。		
还有一些其他的设计模式种，也有使用**组合设计模式**，比如，命令模式，访问者模式，装饰器，都是使用组合设计模式类似的思想。


### UML

![](img/设计模式-组合Composite/UML.png)


### 方法说明

* Component:抽象类，定义结构的主要方法，定义add和remove，根据业务定义业务方法。
* Leaf:子类，结构体内的数据节点。
* Composite:组合体，用于递归存储的机构。
* Client:使用Leaf和Composite构建递归数据结构。


### 优点

一致性，可以构建递归数据结构。


源码地址:
<a>https://github.com/wangypeng/java-design-mode-source/tree/master/composite</a>