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

//     stage('Deploy Infrastructure') {
//       steps {
//         withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'user-aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
//           sh '''
//             terraform init
//             terraform plan -out=tfplan
//             if grep -q 'No changes. Infrastructure is up-to-date.' tfplan; then
//               echo "No changes required."
//             else
//               terraform apply -auto-approve tfplan
//             fi
//           '''
//         }
//       }
//     }

    stage('Deploy Application') {
      steps {
        sshagent(['ec2-key']) {
          sh '''
            ssh -o StrictHostKeyChecking=no ec2-user@my-alb-101849862.us-east-1.elb.amazonaws.com 'bash -s' < sshConnect.sh
          '''
        }
      }
    }
  }
}