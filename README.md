# task desecration

- [✔️] 🐧  1  => Create a gitlab/github repo
- [✔️] 🐧  2  => Create a Jenkins a multibranch pipeline
- [✔️] 🐧  3  => Lint stage
- [✔️] 🐧  4  => Unit test stage
- [✔️] 🐧  5  => SonarQube stage
- [✔️] 🐧  6  => Build stage
- [✔️] 🐧  7  => Deploy springboot app to local Minikub
- [✔️] 🐧  8  => Dev deployment
- [✔️] 🐧  9  => Prod deployment
- [✔️] 🐧  10 => README file to explain the above

## Lint stag 
 #### Make use of docker container in jenkins Pipline that give jenkins more power and avoid and conflict
 ```diff 
-- Lint stage
    stage("Lint stage"){
      
        agent {
          docker {
            image 'gradle'
            args '-v $HOME/.gradle/caches:$HOME/.gradle/caches' 
            }
          }
            
        steps{
          dir("./app"){
              sh ' ./gradlew  check '
          }
        }
    }
 ``` 
 ![plot](/images/0.png)


## Unit test stage
```diff 
--    Unit test stage 

    stage("Unit test stage") {
      agent {
        docker {
          image 'gradle'
          args '-v $HOME/.gradle/caches:$HOME/.gradle/caches'
        }
      }
      steps {
        dir("./app") {
          sh ' ./gradlew  test  '
        }
      }

    }
```
![plot](/images/1.png)

#### ---------------------------------------------------------------------------------------------------------
##  SonarQube stage
####  integrate SonarQube with Jenkins and  scan springboot app with SonarQubeScanner 

```diff 
--  SonarQube stage
    stage("SonarQubeScanner"){
        agent {
            dockerfile true
          }
      steps{
        withSonarQubeEnv(installationName: 'SonarQubeScanner') {
           dir("./app"){
               sh "echo SonarQubeScanner"

              sh "./gradlew sonar \
                -Dsonar.projectKey=${damo} \
                -Dsonar.host.url=${env.SONAR_HOST_URL} \
                -Dsonar.login=${env.SONAR_AUTH_TOKEN} \
                -Dsonar.projectName=${damo} \
                -Dsonar.projectVersion=${BUILD_NUMBER}"
            }
        }
      }
    }
--  wait for the  SonarQube 
+ brack the pipline if SonarQube failed
    stage("Quality Gate") {
      steps {
        sh "echo waitForQualityGate "
        // timeout(time: 2, unit: 'MINUTES') {
        // waitForQualityGate abortPipeline: true
        // }
      }
    }
```
![plot](/images/2.png)
![plot](/images/3.png)
![plot](/images/4.png)

#### Build stage

```diff
--  Build stage
   stage("Build stage") {
      agent {
        docker {
          image 'gradle'
          args '-v $HOME/.gradle/caches:$HOME/.gradle/caches'
        }
      }
      steps {
        dir("./app") {
          sh ' ./gradlew  build  '
        }
      }

    }
 ```
![plot](/images/5.png)

## Create a docker file to dockerize attached spring boot project

```diff 
-- because-of we don't have and version of gradle install on jenkins server
-- we make used of mount volume in docker to build the code of fly
    stage("Build springboot app Image") {
      steps {
        dir("./app") { 
          sh 'docker run  -v "${PWD}":/home/gradle  gradle  ./gradlew build'
          sh ' minikube image build -t  spring-app .'
        }
      }
    }
-- Docker file ------------------------------------
    FROM openjdk:17-jdk-alpine

    WORKDIR /var/server

    RUN addgroup -S webserver && adduser -S  webserver -G webserver

    USER webserver:webserver

    EXPOSE 8080

    ARG JAR_FILE=build/libs/demo-0.0.1-SNAPSHOT.jar

    COPY ${JAR_FILE} /var/server/app.jar

    ENTRYPOINT ["java","-jar","/var/server/app.jar"]   

-- ---------------------------------------------------     

```
![plot](/images/6.png)
![plot](/images/7.png)

## Deploy springboot app to local Minikub
```diff 
-- we need to check for the namespace first
    stage("Carete Name Spaces") {
      steps {

        sh 'bash ./bash-scripts/cheackForNameSpaces.sh'
      }
    }
--  cheackForNameSpaces script -----------------------
    #! /bin/bash

    namespaces=$(kubectl get namespaces)



    if [[ $namespaces = *dev* ]]
    then

    echo "Dev  exist "

    else
    echo  " create namespace Dev deployment "
    kubectl create namespace  dev

    fi 


    if [[ $namespaces = *prod* ]]
    then

    echo "Prod exist "

    else 
    echo  " create namespace Prod "
    kubectl create namespace  prod

    fi 

```

## Dev deployment
```diff
--  dev deployment 

    stage("Dev deployment") {
      steps {
        sh """
          sed -i 's|TEMP|spring-app|g' ./k8s/springBootDeploy.yaml
         """ 
        dir("./k8s") {
          sh ' kubectl apply -f . -n dev'
        }


      }
      post{
         success{

            sh ' minikube service  spring-service  -n dev --url > tump.txt'
            script {
--            save the servire ip
              serverIP = readFile('tump.txt').trim()
            }
          }
          failure{
--  rollout on failure
             sh ' kubectl rollout undo deployment/spring-deploy  -n dev'
          }
      }   
    }
```
![plot](/images/9.png)
## Smake Test for dev
```diff
-- Smoke Test on Dev
    stage("Smoke Test on Dev"){
     when {
        branch 'main'
      }
      steps{
        
        sh "curl ${serverIP}"
      }
      post{
        failure{
              sh ' kubectl rollout undo deployment/spring-deploy  -n dev'
          }
      }
    }
```
![plot](/images/10.png)




