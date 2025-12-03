pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "prakritishrestha515/hello-php-app:latest"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/prakriti515/intuji-devops-internship-challenge.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Login to DockerHub') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub') {
                        echo "Logged into Docker Hub"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub') {
                        dockerImage.push()
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Build and Push Successful!"
        }
        failure {
            echo "Build Failed!"
        }
    }
}

