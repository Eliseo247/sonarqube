FROM jboss/base-jdk:8

MAINTAINER josue <josue.ramirez@ansp.edu.sv>
MAINTAINER Siamak Sadeghianfar <siamaksade@gmail.com>

ENV SONAR_VERSION=7.7 \
    SONARQUBE_HOME=/opt/sonarqube \
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=

USER root
EXPOSE 9000
ADD root /

#set -x \
RUN cd /opt \     
    && curl -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.7.zip \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && rm -rf $SONARQUBE_HOME/bin/*

WORKDIR $SONARQUBE_HOME
COPY run.sh $SONARQUBE_HOME/bin/

RUN useradd -r sonar
USER root
RUN /usr/bin/fix-permissions $SONARQUBE_HOME \
    && chmod 775 $SONARQUBE_HOME/bin/run.sh

USER sonar
ENTRYPOINT ["./bin/run.sh"]
