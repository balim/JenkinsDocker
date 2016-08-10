FROM jenkins:2.7.2-alpine

USER root

COPY plugins.txt /usr/share/jenkins/ref/
COPY job-configurations /opt/irdeto/multiscreen/jenkins/job-configurations/
COPY job-templates /opt/irdeto/multiscreen/jenkins/job-templates/
COPY generateJenkinsJobDSL.sh /opt/irdeto/multiscreen/jenkins/
COPY createJenkinsJob.sh /opt/irdeto/multiscreen/jenkins/
COPY scriptApproval.xml $JENKINS_HOME/scriptApproval.xml

RUN chmod -R 777 /opt/irdeto/multiscreen/jenkins/

RUN ln -s /opt/irdeto/multiscreen/jenkins/createJenkinsJob.sh /usr/bin/createSeedJob
RUN ln -s /opt/irdeto/multiscreen/jenkins/createJenkinsJob.sh /bin/createSeedJob

RUN sed -i "33i\  eval \"exec nohup createSeedJob &\"" /usr/local/bin/jenkins.sh

USER jenkins

RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt
