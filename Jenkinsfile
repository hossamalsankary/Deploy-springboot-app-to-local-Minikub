def serverIP = '0000'
pipeline {
  agent any

  stages {

stage("SonarQubeScanner"){
 
  steps{
  withSonarQubeEnv(installationName: 'SonarQubeScanner') {
           dir("./app"){
               sh """
               docker run \
                    --rm \
                    -e SONAR_HOST_URL='http://ec2-3-140-251-146.us-east-2.compute.amazonaws.com:9000 ' \
                    -e SONAR_SCANNER_OPTS='-Dsonar.projectKey=29993' \
                    -e SONAR_LOGIN='sqp_cebaf350bec84785026eb5bed8fb9a9203b95724' \
                    -v '${PWD}:/usr/src' \
                      sonarsource/sonar-scanner-cli
               """
                }
  }
                  }
}
    

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
            //  sh "./gradlew sonar"
         
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
          sed -i 's|TEMP|spring-app|g'. / k8s / springBootDeploy.yaml
         """ 
        dir("./k8s") {
          sh ' kubectl apply -f . -n dev'
        }
        sh ' minikube service  spring-service  -n dev --url > tump.txt'
        script {
          serverIP = readFile('tump.txt').trim()
        }
      }
      post{
         success{

          sh ' minikube service  spring-service  -n prod --url > tump.txt'
            script {

              serverIP = readFile('tump.txt').trim()

            }
          }
          failure{
             sh ' kubectl rollout undo deployment/spring-deploy  -n dev'
          }
      }
      

    }
    stage("Prod deployment") {
      when {
        branch 'Master'
      }
      steps {
        sh """
        sed  -i 's|TEMP|spring-app|g'. / k8s / springBootDeploy.yaml 
        """

        dir("./app") {
          sh ' kubectl apply -f . -n prod'
        }
     
      }
      post{
         
         success{
          sh ' minikube service  spring-service  -n prod --url > tump.txt'
            script {
              serverIP = readFile('tump.txt').trim()
            }
          }
          failure{
             sh ' kubectl rollout undo deployment/spring-deploy -n prod '
          }
      }

    }

    stage("Smoke Test"){
      steps{
        sh 'curl ${serverIP}'
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
