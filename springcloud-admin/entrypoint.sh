#!/bin/sh
set -x
export SERVICE_NAME=$(echo ${HOSTNAME%-*-*})
export PORT=7020
export DISCOVERY_SERVICE_PORT=8761

export DISCOVERY_URL=$(printf "http://%s:${DISCOVERY_SERVICE_PORT}/eureka" ${DISCOVERY_SERVICE_NAME})

exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar
