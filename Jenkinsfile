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

    stage('Deploy Application') {
      steps {
        sshagent(['ec2-key']) {
          sh '''
            ssh -o StrictHostKeyChecking=no ec2-user@my-alb-36497665.us-east-1.elb.amazonaws.com 'bash -s' < sshConnect.sh
          '''
        }
      }
    }
  }
}