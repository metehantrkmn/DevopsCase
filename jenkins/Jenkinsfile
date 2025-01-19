pipeline {
    agent any

    environment {
        // Move credentials to within stages where they're needed
        DOCKER_IMAGE = 'metehan1171/devops-case:latest'
    }

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    try {
                        git branch: 'main', url: 'https://github.com/metehantrkmn/DevOps-case-jenkins.git'
                    } catch (Exception e) {
                        echo "Failed to clone repository: ${e.getMessage()}"
                        throw e
                    }
                }
            }
        }

        stage('Build and Push') {
            steps {
                script {
                    try {
                        // Build image
                        sh "docker build -t ${DOCKER_IMAGE} ."
                        
                        // Docker Hub login
                        withCredentials([usernamePassword(
                            credentialsId: 'a5884346-f700-4718-b5b7-e73af5fe3bc7',
                            passwordVariable: 'DOCKER_PASSWORD',
                            usernameVariable: 'DOCKER_USERNAME'
                        )]) {
                            sh '''
                                echo "Logging in to Docker Hub..."
                                echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                                echo "Pushing image..."
                                docker push ${DOCKER_IMAGE}
                            '''
                        }
                    } catch (Exception e) {
                        echo "Failed in Build and Push stage: ${e.getMessage()}"
                        throw e
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    try {
                        withKubeConfig([
                            credentialsId: 'kubeconfig',
                            contextName: 'docker-desktop'
                        ]) {
                            sh '''
                                echo "Verifying Kubernetes connection..."
                                kubectl config current-context
                                kubectl get nodes
                                
                                echo "Applying Kubernetes manifests..."
                                kubectl apply -f kubernetes/deployment.yaml
                                kubectl apply -f kubernetes/service.yaml
                                kubectl apply -f kubernetes/ingress.yaml
                                
                                echo "Verifying deployment..."
                                kubectl get pods
                            '''
                        }
                    } catch (Exception e) {
                        echo "Failed in Deploy stage: ${e.getMessage()}"
                        throw e
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    try {
                        sh 'docker logout'
                        echo "Cleanup completed successfully"
                    } catch (Exception e) {
                        echo "Cleanup failed: ${e.getMessage()}"
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline completed - checking credentials..."
            script {
                try {
                    // List available credentials
                    def creds = com.cloudbees.plugins.credentials.CredentialsProvider.lookupCredentials(
                        com.cloudbees.plugins.credentials.common.StandardUsernameCredentials.class,
                        Jenkins.instance,
                        null,
                        null
                    )
                    echo "Available credentials IDs:"
                    creds.each { c -> echo "- ${c.id}" }
                } catch (Exception e) {
                    echo "Failed to list credentials: ${e.getMessage()}"
                }
            }
        }
        success {
            echo 'Deployment Successful!'
        }
        failure {
            echo 'Deployment Failed.'
        }
    }
}