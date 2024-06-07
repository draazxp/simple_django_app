pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'draazxp/simple_django_app:latest'
        EC2_USER = 'ubuntu'
        EC2_HOST = '82.12.77.194'
        SSH_KEY = '/home/draazxp/Downloads/aws-login.pem'
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
        stage('Deploy') {
            steps {
                script {
                    // SSH into the EC2 instance and run the Docker container in interactive mode
                    sh "ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} 'docker pull $DOCKER_IMAGE && docker run -d -p 80:8000 -it $DOCKER_IMAGE'"
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
