pipeline {
  agent any
  environment {
    AWS_DEFAULT_REGION="us-east-1"
    THE_BUTLER_SAYS_SO=credentials('user-aws')
  }
  stages {
    stage('Hello') {
      steps {
        sh '''
          aws --version
          aws ec2 describe-instances
        '''
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
  }
}