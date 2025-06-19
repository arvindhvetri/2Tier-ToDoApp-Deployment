pipeline {
    agent { label 'DSlave' }

    environment {
        DOCKERHUB_IMAGE = 'arvindh01/2tier-todoapp:latest'
        DOCKER_IMAGE = '2tier-todoapp:latest'
    }

    stages {
        stage('Clone Code from GitHub') {
            steps {
                git branch: 'Docker', url: 'https://github.com/arvindhvetri/2Tier-ToDoApp-Deployment.git'
            }
        }

        stage('Build, Push and Deploy Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKERHUB_USERNAME',
                    passwordVariable: 'DOCKERHUB_PASSWORD'
                )]) {
                    sh '''
                    echo "🧹 Stopping and removing any existing containers..."
                    sudo docker ps -a --filter "ancestor=$DOCKER_IMAGE" --format "{{.ID}}" | xargs -r sudo docker rm -f || true
                    sudo docker ps -a --filter "ancestor=$DOCKERHUB_IMAGE" --format "{{.ID}}" | xargs -r sudo docker rm -f || true

                    echo "🔄 Removing old images if they exist..."
                    sudo docker rmi -f $DOCKER_IMAGE || true
                    sudo docker rmi -f $DOCKERHUB_IMAGE || true

                    echo "📦 Building Docker image..."
                    sudo docker build -t 2tier-todoapp .

                    echo "🏷️ Tagging image for Docker Hub..."
                    sudo docker tag 2tier-todoapp $DOCKERHUB_IMAGE

                    echo "🔐 Logging into Docker Hub..."
                    echo "$DOCKERHUB_PASSWORD" | sudo docker login -u "$DOCKERHUB_USERNAME" --password-stdin

                    echo "🚀 Pushing image to Docker Hub..."
                    sudo docker push $DOCKERHUB_IMAGE

                    echo "📦 Running docker-compose up -d..."
                    sudo docker-compose down || true
                    sudo docker-compose up -d
                    '''
                }
            }
        }
    }
}
