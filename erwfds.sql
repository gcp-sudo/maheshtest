ZXCvzxc c zXC A
stage('Checkout') {
            steps {
                // Checkout the repository from Bitbucket with credentials
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/main']],
                          userRemoteConfigs: [[
                              url: 'https://bitbucket.org/your-bitbucket-user/your-repo.git',
                              credentialsId: 'your-bitbucket-credentials-id'
                          ]]])
            }
        }
