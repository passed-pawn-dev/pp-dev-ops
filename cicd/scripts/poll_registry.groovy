// Accept parameters from the job
def params = [
    project: params.PROJECT_NAME,
    githubApiUrl: params.GITHUB_API_URL,
    triggeredPipeline: params.TRIGGERED_PIPELINE
]

pipeline {
    agent any
    parameters {
        string(name: 'PROJECT_NAME', defaultValue: params.project)
        string(name: 'GITHUB_API_URL', defaultValue: params.githubApiUrl)
        string(name: 'TRIGGERED_PIPELINE', defaultValue: params.triggeredPipeline)
    }
    environment {
        LAST_VERSION_COUNT = 0
    }

    stages {
        stage('Poll github package') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'pp-cicd-github-service-account-personal-access-token',
                        usernameVariable: 'REGISTRY_USER',
                        passwordVariable: 'REGISTRY_TOKEN'
                    )
                ]) {
                    script {
                        // Make API request to get current version count
                        def response = sh(script: '
                            curl -s -L \
                            -H "Accept: application/vnd.github+json" \
                            -H "Authorization: Bearer ${REGISTRY_TOKEN}" \
                            -H "X-GitHub-Api-Version: 2022-11-28" \
                            "${GITHUB_API_URL}"
                        ', returnStdout: true)
                        
                        int currentVersionCount = new groovy.json.JsonSlurperClassic()
                            .parseText(response)
                            .version_count as Integer
                        
                        echo "Last version count: ${LAST_VERSION_COUNT}"
                        echo "Current version count: ${currentVersionCount}"
                        
                        // Compare with previous count
                        if (currentVersionCount > LAST_VERSION_COUNT.toInteger()) {
                            echo "New versions detected! Triggering pipeline..."
                            writeFile file: 'version_count.txt', text: currentVersionCount.toString()
                            
                            // Trigger downstream pipeline
                            build job: TRIGGERED_PIPELINE, wait: false
                        } else {
                            echo "No new versions detected."
                        }
                    }
                }
            }
        }
    }
}