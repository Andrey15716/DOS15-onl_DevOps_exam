pipeline {
  agent any
  environment {
    AWS_DEFAULT_REGION="us-east-1"
    THE_BUTLER_SAYS_SO=credentials('user-aws')
    EC2_HOST_1 = "54.86.69.28"
    EC2_HOST_2 = "3.83.141.178"
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
        sshagent(['ec2-key']) {
          script {
            def hosts = [env.EC2_HOST_1, env.EC2_HOST_2]
            for (host in hosts) {
              sh "ssh -o StrictHostKeyChecking=no ubuntu@${host} 'bash -s' < sshConnect.sh"
            }
          }
        }
      }
    }
  }
}