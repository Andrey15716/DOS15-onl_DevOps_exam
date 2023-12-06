pipeline {
    agent any
    stages {
        stage('Deploy') {
            steps {
                script {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}