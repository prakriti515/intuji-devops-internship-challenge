# Intuji DevOps Internship Challenge

**Author:** Prakriti Shrestha  
**GitHub Repository:** [intuji-devops-internship-challenge](https://github.com/prakriti515/intuji-devops-internship-challenge)

---

## Overview

This project demonstrates the complete CI/CD workflow for a Dockerized PHP web application using **Docker**, **Docker Compose**, and **Jenkins**.

Key tasks performed:

1. Install Docker on a Linux VM using a bash script.  
2. Clone a PHP GitHub repository.  
3. Create a Dockerfile to containerize the app.  
4. Push Docker image to Docker Hub.  
5. Create a `docker-compose.yml` to run the application.  
6. Install Jenkins and create a CI/CD pipeline for building, pushing, and deploying the Docker container.  
7. Verify the deployment in a browser.

---

## Prerequisites

- Linux VM (Ubuntu recommended)  
- Git installed  
- Docker & Docker Compose installed  
- Jenkins installed  
- GitHub account with Personal Access Token (PAT)  
- Docker Hub account  

---

## 1. Install Docker

Create a bash script `install-docker.sh`:

```bash
#!/bin/bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl start docker

docker --version
Run the script:

bash
Copy code
chmod +x install-docker.sh
./install-docker.sh
2. Clone the PHP Repository
bash
Copy code
git clone https://github.com/silarhi/php-hello-world.git
cd php-hello-world
3. Create Dockerfile
dockerfile
Copy code
FROM php:8.2-apache
COPY . /var/www/html/
EXPOSE 80
CMD ["apache2-foreground"]
4. Build Docker Image and Push to Docker Hub
bash
Copy code
docker build -t prakritishrestha515/hello-php-app:latest .
docker login
docker push prakritishrestha515/hello-php-app:latest
Verify on Docker Hub: https://hub.docker.com/r/prakritishrestha515/hello-php-app

5. Create docker-compose.yml
yaml
Copy code
version: '3.8'
services:
  web:
    image: prakritishrestha515/hello-php-app:latest
    ports:
      - "8081:80"
Run the application:

bash
Copy code
docker-compose up -d
Open browser: http://<your-server-ip>:8081 → should show "Hello World vlatest"

6. Install Jenkins
bash
Copy code
sudo apt install -y openjdk-17-jdk
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc
sudo sh -c 'echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
Access Jenkins: http://<your-server-ip>:8080

Initial Admin Password:

bash
Copy code
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
Create user: prakriti / prakriti

Install recommended plugins.

7. Jenkins Pipeline (CI/CD)
7.1 Add Jenkins Credentials
Docker Hub credentials → ID: dockerhub

GitHub token → ID: github-token

7.2 Pipeline Job
Create a Pipeline job in Jenkins named php-hello-world-pipeline and add the following Jenkinsfile:

groovy
Copy code
pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "prakritishrestha515/hello-php-app:latest"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/prakriti515/intuji-devops-internship-challenge.git', credentialsId: 'github-token'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}")
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
                    sh 'docker rm -f hello-php-app || true'
                    sh 'docker run -d -p 8081:80 --name hello-php-app prakritishrestha515/hello-php-app:latest'
                }
            }
        }
    }
    post {
        success { echo "Pipeline completed successfully." }
        failure { echo "Pipeline failed. Check logs." }
    }
}
8. Verify Deployment
bash
Copy code
docker ps
Open browser: http://<your-server-ip>:8081 → "Hello World vlatest"

9. Push Everything to GitHub
bash
Copy code
git init
git add .
git commit -m "Initial commit - Dockerized PHP app + Jenkins pipeline"
git branch -M main
git remote add origin https://github.com/prakriti515/intuji-devops-internship-challenge.git
git push -u origin main
10. Screenshots / GIFs
Include screenshots of:

Docker image build

Running container via docker ps

Jenkins pipeline success

Browser displaying app output

Conclusion
PHP application is containerized using Docker.

CI/CD pipeline is implemented with Jenkins.

Docker image pushed to Docker Hub.

Application deployed successfully on VM and verified via browser.

End of Documentation
