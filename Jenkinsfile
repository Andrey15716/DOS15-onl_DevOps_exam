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
             terraform apply -auto-approve
           '''
         }
      }
    }

    stage('Download Index') {
        steps {
           withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'user-aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
              sh '''
                 mkdir -p /home/project/
                 curl -o /var/www/html/index.html https://raw.githubusercontent.com/Andrey15716/DOS15-onl_DevOps_exam/be609f83b3a718ed4f5bed80220e7a9e4390fae5/application/index.html
              '''
           }
        }
    }
  }
}