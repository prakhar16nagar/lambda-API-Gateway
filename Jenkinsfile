pipeline {
    agent any

    stages {
        stage('git Checkout') {
            steps {
                checkout([$class: ‘GitSCM’, branches: [[name: ‘*/main’]], extensions: [], userRemoteConfigs: [[url: ‘https://github.com/prakhar16nagar/lambda-API-Gateway.git‘]]])
            }
        }
        stage (“terraform init”) {
             steps { 
                sh (‘terraform init’)              
             }
        }
        stage (“terraform validate”) {
             steps { 
                sh (‘terraform validate’) 

             }
        }

        stage (“terraform fmt”) {
             steps { 
                sh (‘terraform fmt’) 

             }
        }

         stage (“terraform plan”) {
             steps { 
                sh (‘terraform plan’) 

             }
        }


        stage (“terraform apply”) {
             steps { 
                sh (‘terraform apply –auto-approve’) 

             }
        }

    }
}



        


