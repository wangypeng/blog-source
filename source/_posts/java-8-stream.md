---
title: java 8 stream
date: 2018-07-07 16:54:47
type: "categories"
categories: java8
comments: true
tags: java8
---

### java 8
java 8 中增加很多的新的特性：lambda,stream,函数式编程,新的api。现在java8已经很普及了。工作中也经常用java8：lambda，steam。都是开发中的利器，首先可以增加开发效率，同时也能保证代码的可读性。虽然工作中使用频率还是挺高的，但是比较片面的，最近也是看了一遍《java 8 实战》 这本书，加上自己的一些测试，现在对java 8 的一些新的特性，有了一些更深入的认识。所以，就打算写一遍博客记录下。

### lambda
lambda表达式，函数式标称。其实在之前java也是有支持的，但是并不是那么友好，举个栗子：
<p>java 8之前的版本</p>
<pre>
	<code>
		Runnable a = new Runnable() {
            @Override
            public void run() {
            		doSomeThing();
            }
        };
	</code>
</pre>
这个是定义接口，重写没有实现的方法，java8中增加了@FunctionalInterface,这样的接口就可以直接使用lambda表达式。
<p>java8中的lambda写法：</p>
<pre>
	<code>
		Runnable run = () -> doSomeThing();
	</code>
</pre>
这样，是不是看着很简洁，在了解java8 之前，我很烦java的语法，很冗长，比较喜欢python、golang、js的语法，很简洁。		
lambda表达式各式如下：		
**格式**		
<p></p>
<pre>
	<code>
		// 无参数,直接用()
		() -> {}
		// 一个参数，直接指定，不需要带括号
		 a -> {}
		// 多个参数，需要带括号，把所有参数包起来
		(a,b,x) -> {}
		// 方法只调用一个方法
		() -> doSomeThing()
		// 方法内部有很多逻辑
		() -> {
			doSomeThing();
			// 根据接口方法定义的，是否有返回结果
			return someThing;
		}
	</code>
</pre>
**注意**		
1.函数内部调用外部变量，会默认将外部变量设置为final，所以被调用的外部变量一定不能重新覆盖。	
2.内存函数的return只是返回内部函数返回，和外层函数无关，在forEach中使用lambda表达式，return 只是返回这次的执行，还会继续执行后面循环。而不是整个方法返回跳出循环。

### stream
stream这个是我个人非常喜欢的新特性，一个新的迭代的方式，1.8之前的迭代方式只有两种，一个是for或者增强for，一个是iterator。相较于之前的方式，stream方式处理数据更加灵活。下面介绍下stream处理数据的方式
<table><tr><td colspan="3" align="center">stream操作</td></tr><tr><td rowspan="2">中间操作</td><td>无状态</td><td>unordered() filter() map() mapToInt() mapToLong() mapToDouble()flatMap() flatMapToInt() flatMapToLong() flatMapToDouble() peek()</td></tr><tr><td>有状态</td><td>distinct() sorted() sorted() limit() skip()</td></tr><tr><td rowspan="2">结束操作</td><td>非短路操作</td><td>forEach() forEachOrdered() toArray() reduce() collect() max() min()count()</td></tr><tr><td>短路操作</td><td>distinct() sorted() sorted() limit() skip()</td></tr></table>
