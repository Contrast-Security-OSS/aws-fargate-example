# Dockerfile to run WebGoat 7.1 with Contrast Security

FROM anapsix/alpine-java:jdk8

RUN mkdir /opt/app
RUN mkdir /opt/contrast

RUN apk update && apk add ca-certificates && update-ca-certificates && apk add openssl
RUN apk update; apk add curl
RUN wget https://github.com/WebGoat/WebGoat/releases/download/7.1/webgoat-container-7.1-exec.jar -O /opt/app/webgoat.jar

RUN curl --max-time 20 $CONTRAST__BASEURL/agents/default/JAVA -H API-Key:$APIKey -H Authorization:$Auth -o /opt/contrast/contrast.jar

EXPOSE 8080

CMD ["java","-javaagent:/opt/contrast/contrast.jar","-Dcontrast.protect.rules.sql-injection.detect_tautologies=true","-Dcontrast.server=$SERVER_NAME","-jar","/opt/app/webgoat.jar"]
