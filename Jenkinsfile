pipeline{
    agent any

    stages{
    //     stage("shoow"){
    //         steps{
    //             sh "whoami"
    //             sh "ls ~/"
    //             sh  "ls /home"

    //         }
    //     }
    //     stage("Lint stage"){
    //           agent {
    //                 docker { 
    //                     image 'gradle'
    //                         args '-v $HOME/.gradle/caches:$HOME/.gradle/caches'
    //                         }
    //                 }
    //         steps{
    //             sh 'pwd'
                
    //         dir("./app"){
    //             sh ' ./gradlew  check '
    //         }
               
    //         }

    //     }
    //     stage("Unit test stage"){
    //  agent {
    //                 docker { 
    //                     image 'gradle'
    //                         args '-v $HOME/.gradle/caches:$HOME/.gradle/caches'
    //                         }
    //                 }
    //         steps{
    //        dir("./app"){
    //           sh ' ./gradlew  test  '
    //        }
    //         }

    //     }
    //     stage("SonarQube stage"){
    
    //         steps{
    //        dir("./app"){

    //        }
    //         }

    //     }
        stage("Build stage"){
           agent {
              docker { 
                   image 'gradle'
                    args '-v $HOME/.gradle/caches:$HOME/.gradle/caches -v $HOME/shear:/var/lib/jenkins/workspace/java_app_main@2/app/'
                    }
               }
            steps{
                dir("./app"){

                    sh ' ./gradlew  build  '
                }
            }

        }
        stage("Build springboot app Image"){
            steps{
                dir("./app"){
             sh ' ls $HOME/shear'
                // used gradle image to build onflay
                // sh 'docker run  -v "${PWD}":/home/gradle  gradle  ./gradlew build'
                // sh ' minikube image build -t  spring-app .'
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

             sh """ sed -i 's|TEMP|spring-app|g' ./k8s/springBootDeploy.yaml """ 
            dir("./k8s"){


                sh ' kubectl apply -f . -n dev'
            }
             }

        }

        stage("Smake Test for dev env"){
     
            steps{
                sh """
                SERVIR_IP=$(minikube service spring-service --url -n dev)
                curl $SERVIR_IP

                """
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

        stage("Smake Test for prod env"){
         when {
                branch 'Master'
            }
            steps{
                sh """
                SERVIR_IP=$(minikube service spring-service --url -n prod)
                curl $SERVIR_IP
                """
            }
        }
    }
    post{
    
        success{
                 cleanWs(cleanWhenNotBuilt: false,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true,
                    patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
                               [pattern: '.propsfile', type: 'EXCLUDE']])
        }
        failure{
                  sh ' kubectl delete namespace dev'
                 // sh 'docker system prune -f '
                cleanWs(cleanWhenNotBuilt: false,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true,
                    patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
                               [pattern: '.propsfile', type: 'EXCLUDE']])

        }
    }
}