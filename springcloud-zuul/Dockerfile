FROM registry.newben.net/library/java:openjdk-8-alpine

RUN echo -e "http://mirrors.ustc.edu.cn/alpine/v3.6/main\nhttp://mirrors.ustc.edu.cn/alpine/v3.6/community" > /etc/apk/repositories
RUN apk update
RUN apk add curl

ADD target/*.jar app.jar
ENTRYPOINT [ "java", "-jar", "-Dspring.config.location=/application.yml", "-Djava.security.egd=file:/dev/./urandom", "/app.jar" ]