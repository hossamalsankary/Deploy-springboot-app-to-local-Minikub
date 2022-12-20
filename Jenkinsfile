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
             agent { dockerfile true }
            steps{
        
           sh 'sonar-scanner --version'
        
           dir("./app"){

             
             
              sh """ 
             ./gradlew sonar \
            -Dsonar.projectKey=hoss \
            -Dsonar.host.url=http://ec2-3-128-28-74.us-east-2.compute.amazonaws.com:9000 \
            -Dsonar.login=sqp_413051d5beff2f689d7f49702e0c66cb0fbd13eb
                            """    
                

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
    post{
    
    
        failure{
                sh 'docker system prune --volumes   --force  --all '
                cleanWs()

        }
    }
}