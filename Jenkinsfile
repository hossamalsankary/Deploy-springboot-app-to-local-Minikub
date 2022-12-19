pipeline{
    agent any
    stages{
        // stage("Lint stage"){
        //     steps{
        //     dir("./app"){
        //         sh ' ./gradlew  check '
        //     }
               
        //     }

        // }
        // stage("Unit test stage"){
        //     steps{
        //    dir("./app"){
        //       sh ' ./gradlew  test  '
        //    }
        //     }

        // }
        // stage("SonarQube stage"){
        //     steps{
        //    dir("./app"){

        //    }
        //     }

        // }
        // stage("Build stage"){
        //     steps{
        //   dir("./app"){

        //        sh ' ./gradlew  build  '
        //   }
        //     }

        // }
        stage("Deploy springboot app to local Minikub"){
            steps{
                dir("./app"){

                sh ' docker build  -t spring-app$BUILD_NUMBER .'
                }
            }

        }
        stage("Carete Name Spaces"){
            steps{

                sh 'bash ./bash-scripts/cheackForNameSpaces.sh'
            }
        }
        stage("Dev deployment"){
            
            steps{
            dir("./app"){

                sh 'sed -i "s|TEMP|spring-app$BUILD_NUMBER|g" ./k8s/springBootDeploy.yaml' 

                sh ' kubectl apply -f . -n Dev'
            }
             }

        }
        stage("Prod deployment"){
              when {
                branch 'Master'
            }
            steps{
            dir("./app"){

                sh 'sed -i "s|TEMP|spring-app$BUILD_NUMBER|g"  ./k8s/springBootDeploy.yaml' 

                sh ' kubectl apply -f . -n Prod'
            }
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