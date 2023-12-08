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
          terraform apply -auto-approve
        '''
      }
    }

    stage('Deploy Application') {
      steps {
          sh '''
               ssh -i /home/andrey/DOS15-Antonenko-ec2.pem ec2-user@3.83.141.178
          '''
      }
    }
  }
}