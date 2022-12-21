#!/bin/bash
./gradlew sonar \
-Dsonar.projectKey=k \
-Dsonar.host.url=http://ec2-3-140-251-146.us-east-2.compute.amazonaws.com:9000 \
-Dsonar.login=sqp_cebaf350bec84785026eb5bed8fb9a9203b95724 /
docker run \
    --rm \
    -e SONAR_HOST_URL="http://ec2-3-140-251-146.us-east-2.compute.amazonaws.com:9000 " \
    -e SONAR_SCANNER_OPTS="-Dsonar.projectKey=29993"
    -e SONAR_LOGIN="sqp_cebaf350bec84785026eb5bed8fb9a9203b95724" \
    -v "${PWD}:/usr/src" \
    sonarsource/sonar-scanner-cli