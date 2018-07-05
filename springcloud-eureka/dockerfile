FROM registry.newben.net/library/java:openjdk-8-alpine
ADD target/*.jar discovery-service.jar
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh \
	&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
	&& echo "http://mirrors.ustc.edu.cn/alpine/v3.6/main\nhttp://mirrors.ustc.edu.cn/alpine/v3.6/community" > /etc/apk/repositories
ENTRYPOINT ["/entrypoint.sh"]