#!/usr/bin/env bash

if [ -h ${BASH_SOURCE[0]} ]; then
    WORK_DIR=$( cd "$( dirname "`readlink -f ${BASH_SOURCE[0]}`" )" && pwd )
else
    WORK_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
fi

pushd $WORK_DIR &>/dev/null
    echo "Calling generateJenkinsJobDSL script.."
    ./generateJenkinsJobDSL.sh

    echo "Creating Jenkins Seed Job.."
    while [[ "`curl -uadmin:$(cat /var/jenkins_home/secrets/initialAdminPassword) --head --silent http://localhost:8080/cli/ | grep '200 OK'`" == "" ]]
    do
        echo "..Waiting for Jenkins to start.."
        sleep 1
    done
    until java -jar /var/jenkins_home/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080/ create-job Multiscreen-JobDSL --username admin --password-file /var/jenkins_home/secrets/initialAdminPassword < /opt/irdeto/multiscreen/jenkins/artifacts/multiscreen-seed-job.xml ; do
        echo "..Jenkins is starting, waiting to retry seed job creation.."
        sleep 1
    done
popd &>/dev/null