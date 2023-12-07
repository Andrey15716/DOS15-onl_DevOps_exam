pipeline {
  agent any
  environment {
    AWS_DEFAULT_REGION="us-east-1"
//     THE_BUTLER_SAYS_SO=credentials('user-aws')

  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Deploy Infrastructure') {
      steps {
         withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'user-aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
           sh '''
             terraform init
             terraform plan
             terraform apply -auto-approve -no-color
           '''
         }
      }
    }
  }
}