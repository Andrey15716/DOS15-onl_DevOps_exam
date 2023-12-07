pipeline {
  agent any
  environment {
    AWS_DEFAULT_REGION="us-east-1"
    THE_BUTLER_SAYS_SO=credentials('user-aws')
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Deploy Infrastructure') {
      steps {
         sh '''
           terraform init
           terraform plan
           terraform apply -auto-approve -no-color
         '''
      }
    }

    stage('Update Index') {
      steps {
         sh '''
            sudo rm -rf /var/www/html
            sudo rm -rf /var/www
            curl -o /var/www/html/index.html https://raw.githubusercontent.com/Andrey15716/DOS15-onl_DevOps_exam/main/application/index.html
         '''
      }
    }
  }
}