---
title: Hexo、Github搭建Blog--站内搜索
date: 2018-03-04 22:45:51
type: "categories"
categories: blog
tags: blog
---

![](img/index-page-img/blog.jpg)

<!-- more -->


### 安装
站内搜索主要是通过集成插件的方式实现，步骤如下：		
1. 安装 hexo-generator-search		
	在站点的根目录下执行以下命令：		
`$ npm install hexo-generator-search --save`	
2.	启用搜索		
	编辑blog 根目录_config.yaml:	
	<pre class=“prettyprint”>
	search:
	 path: search.xml
	 field: post
	 format: html
	 limit: 10000
	</pre>