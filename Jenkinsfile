pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'draazxp/simple_django_app:latest'
        EC2_USER = 'ubuntu'
        EC2_HOST = '54.236.29.37'
        SSH_KEY = '/opt/aws-login.pem'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/draazxp/simple_django_app.git', branch: 'main'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build(DOCKER_IMAGE)
                }
            }
        }
        /*
        stage('Test') {
            steps {
                script {
                    dockerImage.inside {
                        sh 'python manage.py test'
                    }
                }
            }
        }
        */
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub') {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Clear Workspace') {
            steps {
                script {
                    // Stop all running containers
                    sh "ssh -i /opt/aws-login.pem -o StrictHostKeyChecking=no ubuntu@54.236.29.37 'docker ps -q --filter \"status=running\" | xargs -r docker stop'"

                    
                    // Remove all stopped containers
                    sh "ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} 'docker rm \$(docker ps -aq)'"
                    
                    // Remove all Docker images
                    sh "ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} 'docker rmi \$(docker images -q)'"
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Pull the latest Docker image
                    sh "ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} 'docker pull $DOCKER_IMAGE'"

                    // Run the Docker container on the EC2 instance
                    sh "ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} 'docker run -d -p 80:8000 $DOCKER_IMAGE'"
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
