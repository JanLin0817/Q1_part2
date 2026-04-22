pipeline {
    agent any

    environment {
        IMAGE_NAME = 'n01742406/three-pages'
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

        stage('Smoke test') {
            steps {
                sh '''
                    docker rm -f smoke-${BUILD_NUMBER} 2>/dev/null || true
                    docker run -d --name smoke-${BUILD_NUMBER} -p 0:80 ${IMAGE_NAME}:${BUILD_NUMBER}
                    sleep 2
                    PORT=$(docker port smoke-${BUILD_NUMBER} 80/tcp | awk -F: '{print $2}')
                    curl -fsSL http://localhost:${PORT}/ | grep -q "Home"
                    curl -fsSL http://localhost:${PORT}/page2.html | grep -q "Page 2"
                    curl -fsSL http://localhost:${PORT}/page3.html | grep -q "Page 3"
                '''
            }
            post {
                always {
                    sh 'docker rm -f smoke-${BUILD_NUMBER} 2>/dev/null || true'
                }
            }
        }
    }

    post {
        success {
            echo "Built ${IMAGE_NAME}:${BUILD_NUMBER} successfully."
        }
    }
}
