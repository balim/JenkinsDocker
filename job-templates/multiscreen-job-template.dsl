pipelineJob('#{JOB_NAME}') {
    displayName('#{JOB_DESCRIPTION}')
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        name('origin')
                        url('#{JOB_GIT_URL}')
                    }
                    extensions {
                        wipeOutWorkspace()
                    }
                    // https://issues.jenkins-ci.org/browse/JENKINS-33719
                    //branch('${GIT_BRANCH}')
                    branch('master')
                }
            }
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

pipelineJob('#{JOB_NAME_BRANCH}') {
    displayName('#{JOB_DESCRIPTION_BRANCH}')
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        name('origin')
                        url('#{JOB_GIT_URL}')
                    }
                    remote {
                        name('${gitlabSourceRepoName}')
                        url('${gitlabSourceRepoURL}')
                    }
                    extensions {
                        wipeOutWorkspace()
                        mergeOptions {
                            remote('origin')
                            branch('${gitlabTargetBranch}')
                        }
                    }
                    branch('${gitlabSourceRepoName}/${gitlabSourceBranch}')
                }
            }
        }
    }
    triggers {
        gitlabPush {
            buildOnMergeRequestEvents(true)
            buildOnPushEvents(true)
            enableCiSkip(false)
            setBuildDescription(true)
            addNoteOnMergeRequest(true)
            rebuildOpenMergeRequest('both')
            addVoteOnMergeRequest(false)
            useCiFeatures(true)
            allowAllBranches(true)
        }
    }
}