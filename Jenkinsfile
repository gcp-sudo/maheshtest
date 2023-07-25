pipeline {
    agent any

    stages {
        stage('Fetch Remote Changes') {
            steps {
                script {
                    // Fetch the latest changes from the remote branch
                    sh 'git fetch origin'
                }
            }
        }

        stage('Checkout') {
            steps {
                // Checkout the repository from GitHub
                // Replace 'your-github-repo-url' with your actual repository URL
                // Make sure you have the necessary credentials configured in Jenkins
                checkout([$class: 'GitSCM',
                          branches: [[name: 'origin/main']], // Replace 'main' with your desired remote branch
                          userRemoteConfigs: [[url: 'https://github.com/gcp-sudo/maheshtest.git']]])
            }
        }

        stage('Identify Changes') {
            steps {
                script {
                    // Get the SHA of the last successful build
                    def lastSuccessfulBuildNumber = currentBuild.previousSuccessfulBuild?.number ?: 0

                    // Get the changes between the last successful build and the current build
                    def changeSet = currentBuild.changeSets.find { it.buildNumber == lastSuccessfulBuildNumber }

                    // Process the changed files and determine if they are modified or newly added
                    def modifiedAndAddedSqlFiles = []

                    if (changeSet) {
                        changeSet.items.each { change ->
                            def filePath = change.path

                            // Check if the file is an .sql file and is either modified or newly added
                            if (filePath.endsWith('.sql') && !filePath.endsWith('parent.sql')) {
                                modifiedAndAddedSqlFiles.add("wewe ${filePath}")
                            }
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
