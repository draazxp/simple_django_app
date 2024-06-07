pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'draazxp/simple_django_app:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/draazxp/simple_django_app.git', branch: 'main'
            }
        }
        stage('Build') {
            steps {
                script {
                    dockerImage = docker.build(DOCKER_IMAGE)
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    dockerImage.inside {
                        sh 'python manage.py test'
                    }
                }
            }
        }
        stage('Push') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials-id') {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Add your deployment steps here
                    // For example, SSH into the server and pull the new Docker image
                    sh 'ssh user@yourserver "docker pull $DOCKER_IMAGE && docker-compose up -d"'
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
