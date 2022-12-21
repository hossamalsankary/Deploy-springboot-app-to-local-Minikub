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
 
