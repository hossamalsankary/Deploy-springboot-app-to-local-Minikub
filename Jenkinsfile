// Create a gitlab/github repo wiht the following;
// Create a docker file to dockerize attached spring boot project
// Create a Jenkins a multibranch pipeline that have the following
//  Unit test stage
//  Deploy springboot app to local Minikub
//  Dev deployment
//  Prod deployment
//  README file to explain the above
def serverIP = '0000'
pipeline {
  agent any

  stages {

// Lint stage
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

// Unit test stage 

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

// SonarQube stage
    stage("SonarQubeScanner"){
        agent {
            dockerfile true
          }
      steps{
        withSonarQubeEnv(installationName: 'SonarQubeScanner') {
           dir("./app"){
                sh 'sleep 10'
              // sh "./gradlew sonar \
              //   -Dsonar.projectKey=${damo} \
              //   -Dsonar.host.url=${env.SONAR_HOST_URL} \
              //   -Dsonar.login=${env.SONAR_AUTH_TOKEN} \
              //   -Dsonar.projectName=${damo} \
              //   -Dsonar.projectVersion=${BUILD_NUMBER}"
            }
        }
      }
    }

// wait for the  SonarQube 
    stage("Quality Gate") {
      steps {
        sh 'sleep 2'
        // timeout(time: 2, unit: 'MINUTES') {
        // waitForQualityGate abortPipeline: true
        // }
      }
    }

// Build stage
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

// Create a docker file to dockerize attached spring boot project
    stage("Build springboot app Image") {
      steps {
        dir("./app") {
          // used gradle image to build our project
          sh 'docker run  -v "${PWD}":/home/gradle  gradle  ./gradlew build'
          sh ' minikube image build -t  spring-app .'
        }
      }
    }

// Deploy springboot app to local Minikub
    stage("Carete Name Spaces") {
      steps {

        sh 'bash ./bash-scripts/cheackForNameSpaces.sh'
      }
    }

// Dev deployment
    stage("Dev deployment") {
      steps {
        sh """
          sed -i 's|TEMP|spring-app|g'./k8s/springBootDeploy.yaml
         """ 
        dir("./k8s") {
          sh ' kubectl apply -f . -n dev'
        }


      }
      post{
         success{

            sh ' minikube service  spring-service  -n dev --url > tump.txt'
            script {
              serverIP = readFile('tump.txt').trim()
            }
          }
          failure{

             sh ' kubectl rollout undo deployment/spring-deploy  -n dev'
          }
      }   
    }

// Prod deployment
    stage("Prod deployment") {
// on Master
      when {
        branch 'Master'
      }
      steps {
        sh """
        sed  -i 's|TEMP|spring-app|g'./k8s/springBootDeploy.yaml 
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

// Smake Test for dev
    stage("Smoke Test on Dev"){
     when {
        branch 'main'
      }
      steps{
        sh 'curl ${serverIP}'
      }
      post{
        failure{
              sh ' kubectl rollout undo deployment/spring-deploy  -n dev'
          }
      }
    }
    
// Smake Test for dev
    stage("Smoke Test on Prod"){
     when {
        branch 'Master'
      }
      steps{
        sh 'curl ${serverIP}'
      }
      post{
        failure{
              sh ' kubectl rollout undo deployment/spring-deploy  -n prod'
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
