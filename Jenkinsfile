pipeline {
  agent any

  stages {

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

    stage("SonarQube stage") {
      agent {
        dockerfile true
      }
      steps {

        sh 'sonar-scanner --version'

        dir("./app") {

          withSonarQubeEnv("sonar-scan-server") {
            //   sh "./gradlew sonar"
            sh ' sleep 10'
          }

        }
      }

    }
    stage("Quality Gate") {
      steps {
        sh 'sleep 2'
        // timeout(time: 2, unit: 'MINUTES') {
        // waitForQualityGate abortPipeline: true
        // }
      }
    }
    stage("Build springboot app Image") {
      steps {
        dir("./app") {
          // used gradle image to build onflay
          sh 'docker run  -v "${PWD}":/home/gradle  gradle  ./gradlew build'
          sh ' minikube image build -t  spring-app .'
        }
      }

    }
    stage("Carete Name Spaces") {
      steps {

        sh 'bash ./bash-scripts/cheackForNameSpaces.sh'
      }
    }
    stage("Dev deployment") {

      steps {

        sh """
          sed - i 's|TEMP|spring-app|g'. / k8s / springBootDeploy.yaml
         """ 
        dir("./k8s") {
          sh ' kubectl apply -f . -n dev'
        }
        
      }
      post{
          failure{
             sh ' kubectl rollout undo deployment/spring-deploy '
          }
      }
      

    }
    stage("Prod deployment") {
      when {
        branch 'Master'
      }
      steps {
        sh """
        sed - i 's|TEMP|spring-app|g'. / k8s / springBootDeploy.yaml 
        """

        dir("./app") {
          sh ' kubectl apply -f . -n prod'
        }
      }
      post{
         
       
          failure{
             sh ' kubectl rollout undo deployment/spring-deploy '
          }
      }

    }
  }
  post {

    failure {
      sh 'docker system prune --volumes   --force  --all '
    //   cleanWs()

    }
  }
}