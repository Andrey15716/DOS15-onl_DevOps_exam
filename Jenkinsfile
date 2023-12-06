pipeline {
    agent any

    environment {
        PREVIOUS_SIZE_FILE = '/home/jenkins/project/previous_size.txt'
        EC2_HOST = "my-alb-640748811.us-east-1.elb.amazonaws.com"
        KEY_PATH = "home/jenkins/project/private_key.pem"
    }

    stages {

        stage('Check Index File Size') {
            steps {
                script {
                    sh 'curl -fsSL -o /home/jenkins/project/index.html https://raw.githubusercontent.com/Andrey15716/DOS15-onl_DevOps_exam/main/application/index.html'
                    currentSize = sh(script: 'stat -c%s index.html', returnStdout: true).trim()
                    if (fileExists(PREVIOUS_SIZE_FILE)) {
                        previousSize = readFile(PREVIOUS_SIZE_FILE).trim()
                        if (currentSize != previousSize) {
                            env.DEPLOY_NEEDED = 'true'
                        }
                    } else {
                        env.DEPLOY_NEEDED = 'true'
                    }
                    writeFile file: PREVIOUS_SIZE_FILE, text: currentSize
                }
            }
        }

        stage('Deploy Infrastructure') {
            when {
                expression { env.DEPLOY_NEEDED == 'true' }
            }
            steps {
                script {
                    sh 'terraform init'
                    sh 'terraform plan'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Update Index') {
            steps {
                 script {
                     sh "scp -o StrictHostKeyChecking=no -i ${KEY_PATH} /home/jenkins/project/index.html ${EC2_HOST}:/var/www/html/index.html"
                 }
            }
        }
    }
}