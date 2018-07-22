---
title: jvm工具-greys
date: 2018-07-14 10:21:22
tags:
---

**摘要**		
最近在工作中，出现了一个接口请求时间较长的情况。但是我了解的java自带的工具，并不能很好的显示整个接口耗时的具体情况。最后也是在github上找到了一个阿里大神写的sh脚本，这个脚本，是用java写的，做了很好的classloader的隔离，并且，很轻量，占用资源很少，安装简便，耗时分析更佳之直观。

**安装步骤**		
1. 首先进入进入安装目录		
2. 安装
<pre>
curl -sLk http://ompc.oss.aliyuncs.com/greys/install.sh|sh
</pre>
3. 开启greys服务
<pre>
./greys <PID>[@IP:PORT]
</pre>
4. 进入greys服务后，进行想要的操作，greys相关命令：如下
<table><tbody><tr><td style="width: 20%;">命令</td><td>说明</td></tr><tr><td><a href="https://github.com/oldmanpushcart/greys-anatomy/wiki/Commands#help">help</a></td><td>查看命令的帮助文档，每个命令和参数都有很详细的说明</td></tr><tr><td><a href="https://github.com/oldmanpushcart/greys-anatomy/wiki/Commands#sc">sc</a></td><td>查看JVM已加载的类信息</td></tr><tr><td><a href="https://github.com/oldmanpushcart/greys-anatomy/wiki/Commands#sm">sm</a></td><td>查看已加载的方法信息</td></tr><tr><td><a href="https://github.com/oldmanpushcart/greys-anatomy/wiki/Commands#monitor">monitor</a></td><td>方法执行监控</td></tr><tr><td><a href="https://github.com/oldmanpushcart/greys-anatomy/wiki/Commands#trace">trace</a></td><td>渲染方法内部调用路径，并输出方法路径上的每个节点上耗时</td></tr><tr><td><a href="https://github.com/oldmanpushcart/greys-anatomy/wiki/Commands#ptrace">ptrace</a></td><td>方强化版的trace命令。通过指定渲染路径，并可记录下路径中所有方法的入参、返值；与tt命令联动。</td></tr><tr><td><a href="https://github.com/oldmanpushcart/greys-anatomy/wiki/Commands#watch">watch</a></td><td>方法执行数据观测</td></tr><tr><td><a href="https://github.com/oldmanpushcart/greys-anatomy/wiki/Commands#tt">tt</a></td><td>方法执行数据的时空隧道，记录下指定方法每次调用的入参和返回信息，并能对这些不同的时间下调用进行观测</td></tr><tr><td><a href="https://github.com/oldmanpushcart/greys-anatomy/wiki/Commands#stack">stack</a></td><td>输出当前方法被调用的调用路径</td></tr><tr><td><a href="https://github.com/oldmanpushcart/greys-anatomy/wiki/Commands#version">version</a></td><td>输出当前目标Java进程所加载的Greys版本号</td></tr><tr><td><a href="https://github.com/oldmanpushcart/greys-anatomy/wiki/Commands#quit">quit</a></td><td>退出greys客户端</td></tr><tr><td><a href="https://github.com/oldmanpushcart/greys-anatomy/wiki/Commands#shutdown">shutdown</a></td><td>关闭greys服务端</td></tr><tr><td><a href="https://github.com/oldmanpushcart/greys-anatomy/wiki/Commands#reset">reset</a></td><td>重置增强类，将被greys增强过的类全部还原</td></tr><tr><td><a href="https://github.com/oldmanpushcart/greys-anatomy/wiki/Commands#jvm">jvm</a></td><td>查看当前JVM的信息</td></tr></tbody></table>

官方github:https://github.com/oldmanpushcart/greys-anatomy/wiki/Getting-Started