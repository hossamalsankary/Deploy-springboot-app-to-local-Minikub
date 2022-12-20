
FROM gradle

WORKDIR /usr/local/bin/

RUN wget  -q https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.7.0.2747-linux.zip

RUN unzip sonar-scanner-cli-4.7.0.2747-linux.zip

ENV PATH="$PATH:/usr/local/bin/sonar-scanner-4.7.0.2747-linux/bin/"
