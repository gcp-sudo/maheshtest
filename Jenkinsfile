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
                    // Fetch the latest changes from the remote branch
                    sh 'git fetch origin'

                    // Get the SHAs of the last two pushes
                    def lastTwoPushesSHAs = sh(returnStdout: true, script: "git rev-list --all --max-count=2").trim().split()

                    // Ensure we have two SHAs
                    if (lastTwoPushesSHAs.size() >= 2) {
                        def lastPushSHA = lastTwoPushesSHAs[1]
                        def currentPushSHA = lastTwoPushesSHAs[0]

                        // Identify the changed .sql files between the last push and the current push
                        def changedFiles = sh(returnStdout: true, script: "git diff --name-status --diff-filter=AM ${lastPushSHA}..${currentPushSHA}").trim()

                        // Split the output into individual lines
                        def changedFilesList = changedFiles.readLines()

                        // Process the changed files and determine if they are modified or newly added
                        def modifiedAndAddedSqlFiles = []

                        changedFilesList.each { filePath ->
                            // Check if the file is an .sql file and is either modified or newly added
                            if (filePath.endsWith('.sql') && !filePath.endsWith('parent.sql')) {
                                modifiedAndAddedSqlFiles.add("!source ${filePath}")
                            }
                        }

                        // Save the modified and newly added .sql files to a new file 'xyz' with their filenames and paths
                        writeFile file: 'xyz', text: "qwsdsdf\nadfsfsdf\n${modifiedAndAddedSqlFiles.join('\n')}\nqwqd\ndsfefg"
                    } else {
                        echo "Not enough commit SHAs found to compare changes."
                    }
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
