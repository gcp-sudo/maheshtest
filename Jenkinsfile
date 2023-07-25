pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout the repository from GitHub
                // Replace 'your-github-repo-url' with your actual repository URL
                // Make sure you have the necessary credentials configured in Jenkins
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/main']], // Replace 'master' with your desired branch
                          userRemoteConfigs: [[url: 'https://github.com/gcp-sudo/maheshtest.git']]])
            }
        }

        stage('Identify Changes') {
            steps {
                script {
                    // Get the SHA of the last commit
                    def lastCommitSHA = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()

                    // Get the SHA of the previous commit
                    def prevCommitSHA = sh(returnStdout: true, script: 'git rev-parse HEAD^').trim()

                    // Identify the changed files since the last commit
                    def changedFiles = sh(returnStdout: true, script: "git diff --name-status ${prevCommitSHA}..${lastCommitSHA}").trim()

                    // Split the output into individual lines
                    def changedFilesList = changedFiles.readLines()

                    // Process the changed files and determine if they are modified or newly added
                    def modifiedFiles = []
                    def newlyAddedFiles = []

                    changedFilesList.each { line ->
                        def parts = line.split()
                        def changeType = parts[0]
                        def filePath = parts[1]

                        // 'A' indicates a newly added file, 'M' indicates a modified file
                        if (changeType in ['A', 'M']) {
                            if (changeType == 'A') {
                                newlyAddedFiles.add(filePath)
                            } else {
                                modifiedFiles.add(filePath)
                            }
                        }
                    }

                    // Display the modified and newly added files
                    echo "Modified Files:"
                    echo modifiedFiles.join('\n')
                    echo "Newly Added Files:"
                    echo newlyAddedFiles.join('\n')
                }
            }
        }
        
        // Add more stages here for additional actions, tests, etc.
    }
}

