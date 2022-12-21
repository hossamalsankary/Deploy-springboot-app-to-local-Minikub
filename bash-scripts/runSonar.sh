#!/bin/bash
./gradlew sonarqube \
-Dsonar.projectKey=k \
-Dsonar.host.url=http://ec2-3-140-251-146.us-east-2.compute.amazonaws.com:9000 \
-Dsonar.login=sqp_cebaf350bec84785026eb5bed8fb9a9203b95724 \
