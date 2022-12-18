pipeline{
    agent any
    stages{
        stage("Lint stage"){
            steps{
                sh ' ./gradlew  check  '
            }

        }
        stage("Unit test stage"){
            steps{
                sh ' ./gradlew  test  '
            }

        }
        stage("SonarQube stage"){
            steps{
                echo "========executing A========"
            }

        }
        stage("Build stage"){
            steps{
               sh ' ./gradlew  build  '
            }

        }
        stage("Deploy springboot app to local Minikub"){
            steps{
                sh ' docker build .'
            }

        }
        stage("Dev deployment"){
            steps{
                sh ' ./gradlew bootRun ' 
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