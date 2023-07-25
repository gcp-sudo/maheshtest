pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout the repository from GitHub
                // Replace 'your-github-repo-url' with your actual repository URL
                // Make sure you have the necessary credentials configured in Jenkins
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/main']], // Replace 'main' with your desired branch
                          userRemoteConfigs: [[url: 'https://github.com/gcp-sudo/maheshtest.git']]])
            }
        }

        stage('Identify Changes') {
            steps {
                script {
                    // Get the SHA of the last commit
                    // def lastCommitSHA = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()

                    // Get the SHA of the previous commit
                   // def prevCommitSHA = sh(returnStdout: true, script: 'git rev-parse HEAD^').trim()

                    // Identify the changed .sql files since the last commit
                    def changedFiles = sh(returnStdout: true, script: "git diff --name-status --diff-filter=AM ").trim()

                    // Split the output into individual lines
                    def changedFilesList = changedFiles.readLines()

                    // Process the changed files and determine if they are modified
                    def modifiedSqlFiles = []

                    changedFilesList.each { line ->
                        def parts = line.split()
                        def changeType = parts[0]
                        def filePath = parts[1]

                        // 'M' indicates a modified file
                        if (changeType == 'M' && filePath.endsWith('.sql')) {
                            modifiedSqlFiles.add(filePath)
                        }
                    }

                    // Save the modified .sql files to a new file 'xyz' with their filenames and paths
                    writeFile file: 'xyz', text: modifiedSqlFiles.join('\n')
                }
            }
        }

        // Add more stages here for additional actions, tests, etc.
        
        stage('Display XYZ Contents') {
            steps {
                script {
                    // Read the contents of the 'xyz' file
                    def xyzContents = readFile(file: 'xyz')
                    // Echo the contents to the Jenkins console output
                    echo "Contents of xyz file:"
                    echo xyzContents
                }
            }
        }
    }
}
