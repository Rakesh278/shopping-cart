pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        REPO_NAME = 'shopping-cart'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        ACCOUNT_ID = credentials('aws-account-id') // stored in Jenkins credentials
    }

    triggers {
        githubPush() // Enables GitHub webhook trigger
    }

    stages {
    stage('Init') {
        steps {
            script {
                env.ECR_URL = "${env.ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com/${env.REPO_NAME}"
            }
        }
    }

        stage('Checkout') { 
            steps {
                checkout scm // checks out the current branch
            }
        }

        stage('Build Java App') {
        steps {
            sh """
            mvn clean package
            """
        }
    }

        stage('Docker Build & Push to ECR') {
            steps {
                sh """
                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL
                    docker build -t $REPO_NAME:latest -t $ECR_URL:$IMAGE_TAG .
                    docker push $ECR_URL:$IMAGE_TAG
                """
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh """
                    sed -i 's|<your-ecr-url>|$ECR_URL:$IMAGE_TAG|' k8s/deployment.yaml
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                """
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful!"
        }
        failure {
            echo "❌ Build failed!"
        }
    }
}