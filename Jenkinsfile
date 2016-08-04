node('dockerhost') {
    GIT_BRANCH = 'master'
    GIT_URL = 'https://github.com/Irdeto-Jenkins2/JenkinsDocker.git'

    def version = "${MAJOR}.${MINOR}.${PATCH}.${env.BUILD_NUMBER}"

    stage name: 'Code Checkout'
    checkout([$class                           : 'GitSCM',
              branches                         : [[name: GIT_BRANCH]],
              doGenerateSubmoduleConfigurations: false,
              extensions                       : [[$class: 'WipeWorkspace']],
              submoduleCfg                     : [],
              userRemoteConfigs                : [[url: GIT_URL]]])

    stage name: 'Build Docker Container'
    docker.build("jenkinsdocker:${version}")

    stage name: 'Deploy Docker Container'
    echo 'Not needed for demo :)'

    sh([script: './generateJenkinsJobDSL.sh'])
    stash includes: 'artifacts/multiscreen-job.dsl', name: 'dsl'
}

stage name: 'Update local Jenkins JobDSL'
input ('JobDSL has been updated, do you want to proceed with updating local instance with these changes?')

node() {
    unstash 'dsl'
    step([$class: 'ExecuteDslScripts', scriptLocation: [scriptText: readFile('artifacts/multiscreen-job.dsl')], ignoreExisting: false, lookupStrategy: 'JENKINS_ROOT', removedJobAction: 'DISABLE', removedViewAction: 'DELETE'])
}