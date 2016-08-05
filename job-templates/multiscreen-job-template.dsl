pipelineJob('#{JOB_NAME}') {
    displayName('#{JOB_DESCRIPTION}')
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        name('origin')
                        url('#{JOB_GIT_URL}')
                        credentials('GitHubSSHCredentialsId')
                    }
                    extensions {
                        wipeOutWorkspace()
                    }
                    // https://issues.jenkins-ci.org/browse/JENKINS-33719
                    //branch('${GIT_BRANCH}')
                    branch('master')
                }
            }
            scriptPath('Jenkinsfile')
        }
    }
    parameters {
        stringParam('MAJOR', '#{MAJOR}', 'Major Version Number.')
        stringParam('MINOR', '#{MINOR}', 'Minor Version Number.')
        stringParam('PATCH', '#{PATCH}', 'Patch Version Number.')
        choiceParam('RELEASE_TYPE', ['release', 'branch'], 'Release type - Branch/Dev build or Release build.')
        stringParam('GIT_BRANCH', 'master', 'Default branch for release builds.')
    }
    triggers {
        scm('H/5 * * * *')
    }
}

multibranchPipelineJob('#{JOB_NAME_BRANCH}') {
    displayName('#{JOB_DESCRIPTION_BRANCH}')
    branchSources {
        branchSource {
            source {
                gitHubSCMSource {
                    repoOwner('Irdeto-Jenkins2')
                    repository('#{JOB_NAME}')
                    buildForkPRHead(false)
                    buildForkPRMerge(false)
                    buildOriginBranch(false)
                    buildOriginBranchWithPR(false)
                    buildOriginPRHead(false)
                    buildOriginPRMerge(true)
                    scanCredentialsId('GitHubTokenCredentialsId')
                    checkoutCredentialsId('GitHubSSHCredentialsId')
                    apiUri('')
                    id('#{JOB_NAME_BRANCH}')
                    includes('*')
                }
            }
        }
    }
}