#!groovy

// Specify Node that has access to the Docker Daemon
node('dockerhost') {
    // Create a stage for checking out the code
    stage name: 'Code Checkout'
    // Since we are doing configuration from SCM, no need to recreate the checkout configuration, just use keyword 'scm'
    checkout scm

    // Let's handle some versioning logic. In this example project we are using Jenkins to manage the Major, Minor, Patch values.
    // So we can determine between a local dev build, a branch build and a release version.
    def version = null
    if (binding.variables.get('RELEASE_TYPE') == 'release') {
        version = "${MAJOR}.${MINOR}.${PATCH}.${env.BUILD_NUMBER}"
    } else {
        branch = ("branch-${env.BUILD_NUMBER}-${env.BRANCH_NAME}" =~ /\\|\/|:|"|<|>|\||\?|\*|\-/).replaceAll("_")
        version = "0.0.0-${branch}.${env.BUILD_NUMBER}"
    }

    // Do a standard container build to be used in testing/deployments
    stage name: 'Build Docker Container'
    docker.build("jenkinsdocker:${version}")

    // Deploy the container somewhere to be used later
    stage name: 'Deploy Docker Container'
    // For demo purposes no need to deploy to a server
    echo 'Not needed for demo :)'

    // Part of our Jenkins environment lets recreate the Job DSL in case we want to update our local instance
    sh([script: './generateJenkinsJobDSL.sh'])
    // Save the file so we can use it later in a different environment/build node
    stash includes: 'artifacts/multiscreen-job.dsl', name: 'dsl'
}

// Example stage to have some manual interaction/approval of the updated JobDSL changes
stage name: 'Update local Jenkins JobDSL'
// Make sure input is not in a node block, otherwise you will be using/blocking 2 executors
input ('JobDSL has been updated, do you want to proceed with updating local instance with these changes?')

// After confirmation we can continue on any node
node() {
    // retrieve the saved dsl artifact so we can run it on any available node.
    unstash 'dsl'
    // Run a general step to execute the DSL
    step([$class: 'ExecuteDslScripts', scriptLocation: [scriptText: readFile('artifacts/multiscreen-job.dsl')], ignoreExisting: false, lookupStrategy: 'JENKINS_ROOT', removedJobAction: 'DISABLE', removedViewAction: 'DELETE'])
}