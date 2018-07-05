#!/bin/sh
set -x

lookupPeers(){
#	PEERS=$(nslookup $SERVICE_NAME 2>/dev/null | grep Address | awk '{print $4}' | awk -F'.' '{printf("http://%s:'${PORT}'/eureka,",$1)}')
	PEERS=$(nslookup $SERVICE_NAME 2>/dev/null | grep Address | awk '{print $4}' | awk '{printf("http://%s:'${PORT}'/eureka,",$1)}')
	export DEFAULT_ZONE=${PEERS%,}
	if [ ! $DEFAULT_ZONE ]; then
		export DEFAULT_ZONE=http://${HOSTNAME}:${PORT}/eureka/
	fi
}

ID=${HOSTNAME:`expr ${#HOSTNAME} - 1`}

if [ -z $SERVICE_NAME ]; then  
	export SERVICE_NAME=$(echo ${HOSTNAME%-*})
fi  

if [ -z $PORT ]; then
	export PORT=8761
fi

if [ -z $WAIT ]; then
	export WAIT=`expr 1000 - 60 \* $ID`
fi

# wait for all eureka peer DNS records registered by kubernetes
sleep $WAIT

lookupPeers

exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /discovery-service.jar