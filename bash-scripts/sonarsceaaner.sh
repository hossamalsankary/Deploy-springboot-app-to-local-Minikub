#!/bin/bash

# download sonar-scaaner
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.7.0.2747-linux.zip

# extract it 
unzip sonar-scanner-cli-4.7.0.2747-linux.zip

export PATH=$PATH:"${PWD}/sonar-scanner-4.7.0.2747-linux/bin/"

