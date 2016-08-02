FROM jenkins:alpine

USER root

COPY plugins.txt /usr/share/jenkins/ref/
COPY job-configurations /opt/irdeto/multiscreen/jenkins/job-configurations/
COPY job-templates /opt/irdeto/multiscreen/jenkins/job-templates/
COPY generateJenkinsJobDSL.sh /opt/irdeto/multiscreen/jenkins/

RUN chmod -R 777 /opt/irdeto/multiscreen/jenkins/

RUN ln -s /opt/irdeto/multiscreen/jenkins/generateJenkinsJobDSL.sh /usr/bin/createSeedJob
RUN ln -s /opt/irdeto/multiscreen/jenkins/generateJenkinsJobDSL.sh /bin/createSeedJob

RUN sed -i "33i\  eval \"exec nohup createSeedJob &\"" /usr/local/bin/jenkins.sh

USER jenkins

RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt