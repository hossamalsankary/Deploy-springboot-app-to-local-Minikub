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

                sh ' docker build  -t spring-app .'
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

            
            dir("./k8s"){


                sh ' kubectl apply -f . -n dev'
            }
             }

        }
        stage("Prod deployment"){
              when {
                branch 'Master'
            }
            steps{
            sh """
             sed -i 's|TEMP|spring-app|g' ./k8s/springBootDeploy.yaml
            """ 
            dir("./app"){

               

                sh ' kubectl apply -f . -n prod'
            }
            }

        }
    }
    post{
        always{
            
            cleanWs(cleanWhenNotBuilt: false,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true,
                    patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
                               [pattern: '.propsfile', type: 'EXCLUDE']])
        
        }
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
                  sh ' kubectl delete namespace dev'
                  sh 'docker system prune -f '

        }
    }
}