---
title: 设计模式-单例【Single】
date: 2018-11-12 19:58:28
type: "categories"
categories: 设计模式
tags: 设计模式
---

![](img/index-page-img/设计模式.png)

单例，只new一次对象，全局只有一个对象实例。

<!-- more -->

### 介绍

单例，在日常开发中，可以说的最常用的。应用的很广泛，也有很多不同的实现。全局只有一个类实例。

### 特点

1.构造函数私有，不能使用 new 直接创建对象。

2.通过静态方法getInstance()方法，创建对象实例。

3.对象实例引用只对自己可见。

### 单例与静态

* 单例：可以持有状态，可以线程安全，可以实现lazy-load，全局只有一个实例。

* 静态：并不能持有状态，线程安全，并在是类加载的时候，就实例了。

### 写法

#### 饿汉模式(推荐)

1. 静态变量
{% codeblock %}
public class Singleton {

	private static Singleton instance=new Singleton();

	private Singleton(){};

	public static Singleton getInstance(){
		return instance;
	}
}

{% endcodeblock %}

2. 静态块
{% codeblock %}
public class Singleton{
 
	private static Singleton instance = null;
		
	static {
		instance = new Singleton();
	}
	 
	private Singleton() {}
	 
	public static Singleton getInstance() {
		return instance;
	}
}
{% endcodeblock %}

**优点**：在类加载的时候，实例化，线程安全。

**缺点**：类加载的时候就实例了。所以这个实例，可能加载了也并不会被使用，会内存浪费。这个种浪费还是能接受的。

#### 懒汉模式

1. 直接创建
{% codeblock %}
public class Singleton {
			 
	private static Singleton instance=null;
	
	private Singleton() {};
	
	public static Singleton getInstance(){
		if(instance==null){
			instance=new Singleton();
		}
		return instance;
	}
}
{% endcodeblock %}

**特点**：非线程安全，可能两条线程请求，可能会创建两个实例。

**不可用**

2. 方法加锁
{% codeblock %}
public class Singleton {
 
	private static Singleton instance=null;
	
	private Singleton() {};
	
	public static synchronized Singleton getInstance(){
		if(instance==null){
			instance=new Singleton();
		}
		return instance;
	}
}
{% endcodeblock %}

**特点**：线程安全，但是性能低下，多线程访问，效率低。

**不可用**

3. 创建时加锁
{% codeblock %}
public class Singleton {
 
	private static Singleton instance=null;

	private Singleton() {};
	
	public static Singleton getInstance() {
		if (instance == null) {
			synchronized (Singleton.class) {
				instance = new Singleton();
			}
		}
		return instance;
	}
}
{% endcodeblock %}

**特点**：非线程安全，两条线程进入if判断，进入synchronized执行。两个线程都会执行，并且都会创建对象

**不可用**

4. 加锁双重验证
{% codeblock %}
public class Singleton {
	
	private static Singleton instance=null;
	
	private Singleton() {};
	
	public static Singleton getInstance(){
		 if (instance == null) {  
	          synchronized (Singleton.class) {  
	              if (instance == null) {  
	            	  instance = new Singleton();  
	              }  
	          }  
	      }  
	      return instance;  
	}
}
{% endcodeblock %}
**特点**：线程安全。双重校验，保证了线程安全和效率。懒汉中

**推荐**

#### 内部类
{% codeblock %}
public class Singleton{
			
	private Singleton() {};
	
	private static class SingletonHolder{
		private static Singleton instance=new Singleton();
	} 
	
	public static Singleton getInstance(){
		return SingletonHolder.instance;
	}
}
{% endcodeblock %}
**特点**：线程安全，延时加载，在调用的时候才加载。效率高

#### 枚举
{% codeblock %}
public enum SingletonEnum {
	
	 instance; 
	 
	 private SingletonEnum() {}
	 
	 public void method(){

	 }
}
{% endcodeblock %}
**特点**：借助JDK1.5中添加的枚举来实现单例模式。不仅能避免多线程同步问题，而且还能防止反序列化重新创建新的对象。代码也非常简单，实在无法不用。这也是新版的《Effective Java》中推荐的模式。

### 源码地址：
<a>https://github.com/wangypeng/java-design-mode-source/tree/master/single</a>
