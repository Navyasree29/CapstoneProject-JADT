pipeline {
    agent any
    environment {
        AWS_REGION = "ap-south-1"
        REPO_NAME = "capstone-app"
        ECR_URI = "390776111022.dkr.ecr.ap-south-1.amazonaws.com/${REPO_NAME}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Navyasree29/CapstoneProject-JADT.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t capstone-app:latest .'
            }
        }

        stage('Push to ECR') {
            steps {
                bat '''
                aws ecr describe-repositories --repository-names capstone-app --region ap-south-1 || aws ecr create-repository --repository-name capstone-app --region ap-south-1
                aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 390776111022.dkr.ecr.ap-south-1.amazonaws.com
                docker tag capstone-app:latest 390776111022.dkr.ecr.ap-south-1.amazonaws.com/capstone-app:latest
                docker push 390776111022.dkr.ecr.ap-south-1.amazonaws.com/capstone-app:latest
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    bat 'terraform init'
                    bat 'terraform apply -auto-approve -var="key_name=capstone-deploy-key"'
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline finished successfully! EC2 instance deployed."
        }
    }
}
