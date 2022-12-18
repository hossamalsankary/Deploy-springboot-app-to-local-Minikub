FROM openjdk:8-jdk-alpine

RUN addgroup -S webserver && adduser -S  webserver -G webserver

USER webserver:webserver


ARG JAR_FILE=build/libs/demo-0.0.1-SNAPSHOT.jar

COPY ${JAR_FILE} app.jar

ENTRYPOINT ["java","-jar","/app.jar"]
