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
        stage("SonarQube stage"){
         agent {
              docker { 
                   image 'gradle'
                   args '-v $HOME/.gradle/caches:$HOME/.gradle/caches'

                   
                    }
               }
            steps{
        
        sh """#!/bin/bash
        wget  -q https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.7.0.2747-linux.zip
            unzip sonar-scanner-cli-4.7.0.2747-linux.zip
            sudo mv sonar-scanner-4.7.0.2747-linux /opt/sonar-scanner
            export PATH="$PATH:/opt/sonar-scanner/bin"
        """
        sh 'sonar-scanner '
        
           dir("./app"){

            //   withSonarQubeEnv(installationName: 'sq1') { 
             
            //         //     sh """
                        
            //         //     export PATH=$PATH:$PWD/sonar-scanner-4.7.0.2747-linux/bin/
                        
            //         //    echo $PATH
            //         //      """
            //            // ./gradlew sonar
            //     }

           }
            }

        }
        // stage("Build stage"){
        //    agent {
        //       docker { 
        //            image 'gradle'
        //             args '-v $HOME/.gradle/caches:$HOME/.gradle/caches'
        //             }
        //        }
        //     steps{
        //         dir("./app"){

        //             sh ' ./gradlew  build  '
        //         }
        //     }

        // }
        // stage("Build springboot app Image"){
        //     steps{
        //         dir("./app"){
        //         // used gradle image to build onflay
        //         sh 'docker run  -v "${PWD}":/home/gradle  gradle  ./gradlew build'
        //         sh ' minikube image build -t  spring-app .'
        //         }
        //     }

        // }
        // stage("Carete Name Spaces"){
        //     steps{

        //         sh 'bash ./bash-scripts/cheackForNameSpaces.sh'
        //     }
        // }
        // stage("Dev deployment"){
            
        //     steps{

        //      sh """
        //      sed -i 's|TEMP|spring-app|g' ./k8s/springBootDeploy.yaml
        //     """ 
        //     dir("./k8s"){


        //         sh ' kubectl apply -f . -n dev'
        //     }
        //      }

        // }
        // stage("Prod deployment"){
        //       when {
        //         branch 'Master'
        //     }
        //     steps{
        //     sh """
        //      sed -i 's|TEMP|spring-app|g' ./k8s/springBootDeploy.yaml
        //     """ 
        //     dir("./app"){
        //         sh ' kubectl apply -f . -n prod'
        //     }
        //     }

        // }
    }
    // post{
    
    
    //     failure{
    //              // sh 'docker system prune -f '
    //             cleanWs(cleanWhenNotBuilt: false,
    //                 deleteDirs: true,
    //                 disableDeferredWipeout: true,
    //                 notFailBuild: true,
    //                 patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
    //                            [pattern: '.propsfile', type: 'EXCLUDE']])

    //     }
    // }
}