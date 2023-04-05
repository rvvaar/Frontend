//def nazwa zmiennej=zmienna

def imageName="rvvar/frontend"
def dockerRegistry=""
def registryCredentials="dockerhub"
def dockerTag=""

pipeline {
    agent {
        label 'agent'
        }
    environment {
         scannerHome = tool 'SonarQube'
                }
    stages {
        stage('Get code') {
            steps {
                checkout scm // Get some code from a GitHub repository
            }
        }
        stage('Run tests') {
            steps {
                sh "pip3 install -r requirements.txt"
                sh "python3 -m pytest --cov=. --cov-report xml:test-results/coverage.xml --junitxml=test-results/pytest-report.xml"
            }
        }
        stage('Sonarqube analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
                timeout(time: 1, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('Build app') {
            steps {
                script {
                    dockerTag = "RC-${env.BUILD_ID}" //.${env.GIT_COMMIT.take(7)}"
                    applicationImage = docker.build("$imageName:$dockerTag")
                }
            }
        }
        stage('Send image to Artifactory') {
            steps {
                script{
                    docker.withRegistry("$dockerRegistry","$registryCredentials")
                    {
                    applicationImage.push()
                    applicationImage.push("latest")
                    }
                }
            }
        }
    }
    post {
        always {
            junit testResults: "test-results/*.xml"
            cleanWs()
        }
    }
}