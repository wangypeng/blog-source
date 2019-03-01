---
title: docker-基础命令及使用
date: 2018-09-14 14:58:01
type: "categories"
categories: docker
tags: docker
---

![](img/index-page-img/docker.jpeg)

docker基本使用

<!-- more -->

### 介绍

docker最近这几年比较火，云计算，容器编排应用也越来月广，这一切的基础都是docker。所以介绍一下，docker的一些基本使用。

### 安装

三种方式：

* 官网直接下载对应版本，但是没有vpn的小伙伴可能会很慢。
```
https://docs.docker.com/ 
```
* cli工具
```
// sudo 
brew install
// linux 
yum install docker
```
* 国内阿里云，有安装包，需要登陆。

### 配置

#### mac

我使用的版本号：17.09
docker默认是使用docker官网的dockerhub，没有vpn，可以使用阿里云的镜像。 

##### 配置步骤

1. 打开Docker->Preferences->deamon
2. Insecure registries配置:registry.mirrors.aliyuncs.com
3. Registry mirrors配置自己的镜像加速器地址即可.
重启docker生效
使用淘宝的账号就行

登陆阿里的镜像库，可以直接将自己的制作的镜像push到镜像空间中
```
sudo docker login --username=xxxx
registry.cn-hangzhou.aliyuncs.com
```

#### linux 

修改deamon.json配置文件，这个我没有实践，就不误人子弟了。可以去网上找，有很多详细的讲解。

### 使用

1. docker search 搜索命令名称
```
docker search ubuntu
```

  不是系统源镜像，例如java、node这样的镜像，镜像里面是有整套的环境，可以查看镜像dockerfile，查看镜像的内部环境

2. docker pull  镜像名称   直接从dockerhub 拉取镜像
```
docker pull ubuntu
```

 可以阿里镜像库，直接拉取镜像库的镜像，镜像需跟上url

3. docker run 启动容器
```
docker run option
```
	参数如下:		

	**-i** 以交互模式运行容器，通常与 -t 同时使用		
	**-t** 启动容器直接进入容器CLI，进入容器的伪输入终端	
	**-d** 容器后台运行		
	**-h** 指定容器的hostname		
	**-rm** 容器推出后直接删除容器		
	**-v** /host_file:/container_file host_file为宿主机文件路径 /container_file为容器内部的映射的文件路		
	**-p** host_port:container_port host_port为宿主机端口，container_port为容器内部的端口
	**-P** 是容器内部端口随机映射到主机的高端口，**注**：-p和-P设置完端口，可以使用docker ps -a查看容器的端口映射			
	**--name** containerName 指定容器的名称
	
	资源限制参数：
	**-e username="ritchie"** : 设置环境变量；
	**-m** :设置容器使用内存最大值；	
	**--cpuset="0-2"** : 绑定容器到指定CPU运行	
4. docker stop containerID/containerName 停止容器，根据容器ID或者容器的名称
```
docker stop mynode1
```

5. docker rm containerID/containerName  删除容器，根据容器的ID或者容器的名称
```
docker rm containerID/containerName
```
	快捷操作
	docker rm `docker ps -a -q` 全部删除容器
	docker rm $(docker ps -a -q) 一样是先查询全部的容器id再删除

6. docker rmi imagesID/imgeName 删除容器，根据镜像的ID或者镜像的名称	
在删除镜像的时候，要保证没有使用这个镜像的容器。会报
 image is being used by stopped container 2a248b9ad5976

7. docker ps [options]查询容器状态
   **-a** all 查看全部的镜像
   **-l**  last 查看最后一个运行的镜像
   **-q** 只显示容器编号
8. docker commit 提交容器
9. docker inspect containerID 查看容器的相关参数
```
docker inspect --format '{{ .NetworkSettings.IPAddress }}' containerID
```
查看全部的容器的ip




