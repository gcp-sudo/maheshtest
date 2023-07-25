def getChangedFilesList() {
    def changedFiles = []
    try {
        for (changeLogSet in currentBuild.changeSets) {
            for (entry in changeLogSet.getItems()) { // for each commit in the detected changes
                for (file in entry.getAffectedFiles()) {
                    changedFiles.add(file.getPath()) // add changed file to list
                }
            }
        }
    } catch (Exception e) {
        echo "Error occurred while identifying changes: ${e.message}"
    }
    return changedFiles
}

pipeline {
    agent any

    stages {
        stage('Check for Changes') {
            steps {
                script {
                    // Call the function to get the list of changed files
                    def changedFilesList = getChangedFilesList()

                    // If there are no changed files, proceed to the Display XYZ Contents stage directly
                    if (changedFilesList.isEmpty()) {
                        echo "No changes detected. Skipping Identify Changes stage."
                        build 'Display XYZ Contents'
                    }
                }
            }
        }

        stage('Checkout') {
            steps {
                // Checkout the repository from GitHub
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/main']],
                          userRemoteConfigs: [[url: 'https://github.com/gcp-sudo/maheshtest.git']]])
            }
        }

        stage('Identify Changes') {
            steps {
                script {
                    // Call the function to get the list of changed files
                    def changedFilesList = getChangedFilesList()

                    // Process the changed files and determine if they are modified or newly added .sql files
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
