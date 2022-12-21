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


