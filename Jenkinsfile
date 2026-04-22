pipeline {
    agent any

    environment {
        IMAGE_NAME      = 'chris07l/three-pages'
        DOCKERHUB_CREDS = credentials('dockerhub-creds')
    }

    triggers {
        pollSCM('* * * * *')
    }

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} -t ${IMAGE_NAME}:latest .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh '''
                    echo "$DOCKERHUB_CREDS_PSW" | docker login -u "$DOCKERHUB_CREDS_USR" --password-stdin
                    docker push ${IMAGE_NAME}:${BUILD_NUMBER}
                    docker push ${IMAGE_NAME}:latest
                '''
            }
        }
    }

    post {
        success {
            echo "Built & pushed ${IMAGE_NAME}:${BUILD_NUMBER}"
        }
        always {
            sh 'docker logout || true'
        }
    }
}
