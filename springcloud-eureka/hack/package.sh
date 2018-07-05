#!/bin/sh
set -x
set -e
mvn package
docker build . -t mirror.ghostcloud.cn/microservice/eureka-server:1.0
docker push mirror.ghostcloud.cn/microservice/eureka-server:1.0