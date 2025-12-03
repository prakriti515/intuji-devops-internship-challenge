pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "prakritishrestha515/hello-php-app:latest"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/prakriti515/php-hello-world.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub') {
                        echo "Authenticated to Docker Hub."
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

        stage('Deploy Container') {
            steps {
                script {
                    sh "docker rm -f php-hello-world || true"
                    sh "docker run -d --name php-hello-world -p 8081:80 ${DOCKER_IMAGE}"
                }
            }
        }
    }

    post {
        success {
            echo "Build, Push & Deploy Completed Successfully!"
        }
        failure {
            echo "Pipeline Failed! Check logs."
        }
    }
}

