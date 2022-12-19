pipeline{
    agent any
    stages{
        stage("Lint stage"){
            steps{
            dir("./app"){
                sh 'kubectl get pod'
                sh ' ./gradlew  check '
            }
               
            }

        }
        stage("Unit test stage"){
            steps{
           dir("./app"){
              sh ' ./gradlew  test  '
           }
            }

        }
        stage("SonarQube stage"){
            steps{
           dir("./app"){

           }
            }

        }
        stage("Build stage"){
            steps{
          dir("./app"){

               sh ' ./gradlew  build  '
          }
            }

        }
        stage("Deploy springboot app to local Minikub"){
            steps{
                dir("./app"){

                sh ' docker build  -t webserver$BUILD_NUMBER .'
                }
            }

        }
        stage("Dev deployment"){
            steps{
            dir("./app"){

                sh ' ./gradlew bootRun ' 
            }
             }

        }
        stage("Prod deployment"){
            steps{
                echo "========executing A========"
            }

        }
    }
    post{
        always{
            echo "========always========"
        }
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}