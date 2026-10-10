pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'abirami0901'
        IMAGE          = "${DOCKERHUB_USER}/trend-app"
        TAG            = "${env.BUILD_NUMBER}"
        AWS_REGION     = 'us-east-1'
        CLUSTER_NAME   = 'trend-eks'
    }

    triggers {
        githubPush()   // fired by the GitHub webhook
    }

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $IMAGE:$TAG -t $IMAGE:latest .'
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                                  usernameVariable: 'DH_USER',
                                                  passwordVariable: 'DH_PASS')]) {
                    sh '''
                        echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin
                        docker push $IMAGE:$TAG
                        docker push $IMAGE:latest
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                    aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
                    kubectl apply -f k8s/
                    kubectl set image deployment/trend-app trend=$IMAGE:$TAG
                    kubectl rollout status deployment/trend-app --timeout=120s
                    kubectl get svc trend-service
                '''
            }
        }
    }

    post {
        always { sh 'docker logout || true' }
    }
}
