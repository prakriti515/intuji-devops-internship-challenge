pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "prakritishrestha515/hello-php-app:latest"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/prakriti515/intuji-devops-internship-challenge.git'
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
                        echo "Authenticated to Docker Hub"
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

        // ✅ Add Deploy stage here
        stage('Deploy Container') {
            steps {
                script {
                    // Remove previous container if exists
                    sh 'docker rm -f hello-php-app || true'
                    // Run new container
                    sh 'docker run -d --name hello-php-app -p 8081:80 prakritishrestha515/hello-php-app:latest'
                }
            }
        }
    }

    post {
        success {
            echo "Build -> Push -> Deploy complete."
        }
        failure {
            echo "Pipeline failed. Check console output."
        }
    }
}

