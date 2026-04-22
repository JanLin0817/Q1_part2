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
    }

    post {
        success {
            echo "Built ${IMAGE_NAME}:${BUILD_NUMBER} successfully."
        }
    }
}
