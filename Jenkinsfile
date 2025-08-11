pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        REPO_NAME = 'shopping-cart-app'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    triggers {
        githubPush() // Enables GitHub webhook trigger
    }

    stages {
    stage('Init') {
    steps {
        withCredentials([
            string(credentialsId: 'aws-account-number', variable: 'ACCOUNT_ID'),
            usernamePassword(credentialsId: 'aws-ecr-creds', usernameVariable: 'AWS_ACCESS_KEY', passwordVariable: 'AWS_SECRET_KEY')
        ]) {
            script {
                env.ECR_URL = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}"
                env.AWS_ACCESS_KEY_ID = AWS_ACCESS_KEY
                env.AWS_SECRET_ACCESS_KEY = AWS_SECRET_KEY
            }
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
            cd shoppin-cart
            mvn clean package
            """
        }
    }

        stage('Docker Build & Push to ECR') {
        steps {
        sh '''
            aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL
            JAR_NAME=$(find shoppin-cart/target -name "*.jar" | grep -v "original" | head -n 1)
            docker build --build-arg JAR_FILE=$JAR_NAME -t $REPO_NAME:latest -t $ECR_URL:$IMAGE_TAG .
             docker push $ECR_URL:$IMAGE_TAG
            '''
        }
    }

        stage('Deploy to EKS') {
            steps {
                sh """
                 /usr/local/bin/kubectl apply -f k8s/deployment.yaml
                /usr/local/bin/kubectl apply -f k8s/service.yaml
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