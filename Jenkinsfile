pipeline {
    agent any
    stages {
         stage('Setup Python/Django Environment'){
            steps {
                sh '''
                    chmod +x etc/jnk/env.setup.sh
                    etc/jnk/env.setup.sh
                    '''
            }
        }
        stage('Testing Application'){
            steps {
                sh '''
                    chmod +x etc/jnk/testing.sh
                    etc/jnk/testing.sh
                    '''
            }
        }
        stage('Setup Gunicorn File'){
            steps {
                sh '''
                    chmod +x etc/jnk/gunicorn.sh
                    etc/jnk/gunicorn.sh
                    '''
            }
        }
        stage('Setup Supervisor Service'){
            steps {
                sh '''
                    chmod +x etc/jnk/supervisor.sh
                    etc/jnk/supervisor.sh
                    '''
            }
        }
        stage('Setup Nginx Service'){
            steps {
                sh '''
                    chmod +x etc/jnk/nginx.sh
                    etc/jnk/nginx.sh
                    '''
            }
        }
    }
}
