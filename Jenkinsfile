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
        //  agent {
        //       docker { 
        //            image 'gradle'
        //             args '-v $HOME/.gradle/caches:$HOME/.gradle/caches'
        //             }
        //        }
            steps{
           dir("./app"){

            sh """
                docker run \
                       --rm \
                       -e SONAR_HOST_URL="http://ec2-3-128-28-74.us-east-2.compute.amazonaws.com:9000" \
                       -e SONAR_SCANNER_OPTS="-Dsonar.projectKey=${PWD}"
                       -e SONAR_LOGIN="sqp_898df437dc73d7325a79edfea44e029a37b4c40e" \
                       -v "${PWD}:/src" sonarsource/sonar-scanner-cli
            """
                //     withSonarQubeEnv(installationName: 'sq1') { 
                //           sh """  gradle sonar   -Dsonar.projectKey=test '
                //            """
                // }
        //     sh """
        //  ./gradlew sonar \
        //     -Dsonar.projectKey=test \
        //     -Dsonar.host.url=http://ec2-3-128-28-74.us-east-2.compute.amazonaws.com:9000 \
        //     -Dsonar.login=sqp_898df437dc73d7325a79edfea44e029a37b4c40e
       
        //         """
           }
            }

        }
        stage("Build stage"){
           agent {
              docker { 
                   image 'gradle'
                    args '-v $HOME/.gradle/caches:$HOME/.gradle/caches'
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
                // used gradle image to build onflay
                sh 'docker run  -v "${PWD}":/home/gradle  gradle  ./gradlew build'
                sh ' minikube image build -t  spring-app .'
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

             sh """
             sed -i 's|TEMP|spring-app|g' ./k8s/springBootDeploy.yaml
            """ 
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