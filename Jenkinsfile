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
        stage('Clean Workspace') {
            steps {
                // Clean the workspace to remove files from the previous build
                cleanWs()
            }
        }

        stage('Check for Changes') {
            steps {
                script {
                    // Call the function to get the list of changed files
                    def changedFilesList = getChangedFilesList()

                    // If there are no changed files, proceed to the Display XYZ Contents stage directly
                    if (changedFilesList.isEmpty()) {
                        echo "No changes detected. Displaying the previous 'xyz' file."
                        build 'Display XYZ Contents'
                        return
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
        stage('Copy SQL Files to Change Request Folder') {
            // This stage copies the SQL files to a "changerequest" folder,
            // separated by a date folder.
            when {
                // Only execute this stage if the previous stages were successful.
                expression { currentBuild.result == 'SUCCESS' }
            }
            steps {
                script {
                    def currentDate = sh(returnStdout: true, script: 'date +%Y-%m-%d').trim()
                    def buildNumber = currentBuild.number
                    def changeRequestFolder = "changerequest/${currentDate}/build${buildNumber}"
                    
                    // Create the date folder and build folder
                    sh "mkdir -p ${changeRequestFolder}"
                    
                    // Stash the modified and newly added .sql files along with their directory structure
                    stash name: 'sql_files', includes: '**/*.sql', allowEmpty: true
                    
                    // Unstash the .sql files in the "Display XYZ Contents" stage
                    unstash 'sql_files'
                    
                    // Move the .sql files to the change request folder preserving their directory structure
                    sh "cp -R **/*.sql ${changeRequestFolder}"
                }
            }
        }

    }
}
