FROM openjdk:17-jdk-alpine

WORKDIR /var/server

RUN addgroup -S webserver && adduser -S  webserver -G webserver

USER webserver:webserver

EXPOSE 8080

ARG JAR_FILE=build/libs/demo-0.0.1-SNAPSHOT.jar

COPY ${JAR_FILE} /var/server/app.jar

ENTRYPOINT ["java","-jar","/var/server/app.jar"]
