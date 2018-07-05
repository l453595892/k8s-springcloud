# 说明

本项目为容器化 `eureka server`，并针对运行在Kubernetes环境中做相应定制：

1. 节点之间可以通过kubernetes dns发现对方；
2. 自动使用kubernetes服务名作为spring cloud应用名；
3. 通过Kubernetes环境变量配置`eureka`相关配置参数，并做默认优化。

默认端口`8761`,使用kubernetes部署时需要部署为有状态的服务。

## 第一步：创建支持Eureka Server的Spring Boot工程

通过`http://start.spring.io/` 创建一个Spring Boot工程，具体参数如下：

- Generate a "Maven Project" with "Java" and Spring Boot"1.5.6"
- ProjectMetadata Group: cn.ghostcloud
- Artifact: eurekaserver
- Dependencies: Eureka Server

然后点击"Generate Project"即可得到一个包含eureka server的Spring boot工程。

在生成的工程中，pom.xml中增加了eureka-server的依赖如下：

~~~
<dependency>  
    <groupId>org.springframework.cloud</groupId>  
    <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>  
</dependency>  
~~~

## 第二步：增加EnableEurekaServer注解及注册中心配置

1. 为EurekaserverApplication类增加注解`@EnableEurekaServer`，启动服务注册中心
2. 添加resource中添加`application.yml`文件，配置相关参数：

~~~
server:
    port: ${PORT:8761}
 
eureka:
    instance:
        hostname: ${HOST:localhost}
    client:
        registerWithEureka: false
        fetchRegistry: false
    server:
        enableSelfPreservation: false
~~~

其中hostname可以不配置，会自动侦测主机名，配置错误和`defaultZone`中不一致会导致状态为`unavailable-replicas`

## 第三步：打包运行

执行 `sh build.sh` 将自动编译代码，并生成docker镜像

## 常见问题

- Spring Cloud中，Eureka常见问题总结：http://www.itmuch.com/spring-cloud-sum-eureka/
- 了解Spring Cloud Eureka Server自我保护和更新阈值：http://www.developerq.com/article/1506828697
- Dive into Eureka：http://nobodyiam.com/2016/06/25/dive-into-eureka/

**DNS自动动态配置节点**

- eureka集群基于DNS配置方式：http://www.cnblogs.com/relinson/p/eureka_ha_use_dns.html

**Eureka Server间无法同步数据**

请注意，Eureka Server相互注册后可能出现无法同步数据的情况。具体表现是每个Eureka Server上的续约数都不一样，同时在General Info标签下别的Eureka Server显示为`unavailable-replicas`。

这是因为Eureka通过`serviceUrl.defaultZone`解析到副本的hostname，与实例互相注册时的hostname对比，来判断副本是不是available。而我们application.properties的配置是：

```
eureka.client.serviceUrl.defaultZone=http://ds-0:8761/,http://ds-1:8761/
```

这就导致Eureka认为这两个Server的hosts应该是ds-0和ds-1。但实际上，这两台机器的hostname配置却是hz-kfk-01和hz-kfk-02，这就导致Eureka Server相互注册时使用的hostname也是hz-kfk-01和hz-kfk-02。因此，这两台Eureka Server被判定为unavailable。

解决这个问题的方式是保证配置和机器实际的hostname配置一致。实际上，我们也可以配置`eureka.instance.preferIpAddress=true`来保证Eureka Server相互注册时hostname使用IP地址，同时使用IP地址作为`eureka.client.serviceUrl.defaultZone`的配置值。
