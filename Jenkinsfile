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
                    // Get the SHA of the last successful commit
                    def lastSuccessfulCommitSHA = env.GIT_PREVIOUS_SUCCESSFUL_COMMIT ?: sh(returnStdout: true, script: 'git rev-parse HEAD').trim()

                    // Get the SHA of the current commit
                    def currentCommitSHA = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()

                    // Identify the changed .sql files between the last successful commit and the current commit
                    def changedFiles = sh(returnStdout: true, script: "git diff --diff-filter=AM --name-only ${lastSuccessfulCommitSHA}..${currentCommitSHA}").trim()

                    // Split the output into individual lines
                    def changedFilesList = changedFiles.readLines()

                    // Process the changed files and determine if they are modified or newly added
                    def modifiedAndAddedSqlFiles = []

                    changedFilesList.each { filePath ->
                        // Check if the file is an .sql file and is either modified or newly added
                        if (filePath.endsWith('.sql') && !filePath.endsWith('parent.sql')) {
                            modifiedAndAddedSqlFiles.add("wewe ${filePath}")
                        }
                    }

                    // Save the modified and newly added .sql files to a new file 'xyz' with their filenames and paths
                    writeFile file: 'xyz', text: "qwsdsdf\nadfsfsdf\n${modifiedAndAddedSqlFiles.join('\n')}\nqwqd\ndsfefg"
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
