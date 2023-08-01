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
def getChangedFilesList() {
    // Function implementation to identify changed files
    // (This part remains unchanged from your original script)
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
                    
                    // Check if the date folder exists, if not, create it
                    sh "mkdir -p changerequest/${currentDate}"
                    
                    // Check if the build folder exists, if not, create it
                    sh "mkdir -p ${changeRequestFolder}"
                    
                    // Call the function to get the list of changed files
                    def changedFilesList = getChangedFilesList()

                    // Process the changed files and determine if they are modified or newly added .sql files
                    def modifiedAndAddedSqlFiles = []

                    changedFilesList.each { filePath ->
                        // Check if the file is an .sql file
                        if (filePath.endsWith('.sql')) {
                            // If it's a parent.sql file, extract the modified .sql contents
                            if (filePath.endsWith('parent.sql')) {
                                def modifiedContents = readFile(file: filePath)
                                modifiedAndAddedSqlFiles.addAll(modifiedContents.readLines().findAll { it.endsWith('.sql') })
                            } else {
                                // Otherwise, add the file directly to the list
                                modifiedAndAddedSqlFiles.add(filePath)
                            }
                        }
                    }

                    // Move the .sql files to the change request folder preserving their directory structure
                    modifiedAndAddedSqlFiles.each { sqlFile ->
                        sh "cp --parents ${sqlFile} ${changeRequestFolder}"
                    }
                }
            }
    }
}
