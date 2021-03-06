FROM xjboss/openjdk:stretch
#Install maven
ENV MAVEN_VERSION 3.6.0
ENV MAVEN_HOME /usr/share/maven
COPY --from=maven:3.6-jdk-8-alpine /usr/share/maven ${MAVEN_HOME}

#Install gradle
ENV GRADLE_VERSION 5.3.1
ENV GRADLE_HOME /usr/share/gradle
COPY --from=gradle:5.3.1-jre8-alpine /opt/gradle ${GRADLE_HOME}

#Install jenkins
#RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG http_port=8080
ARG agent_port=50000
ARG JENKINS_HOME=/var/jenkins_home

ENV JENKINS_HOME $JENKINS_HOME
ENV JENKINS_SLAVE_AGENT_PORT ${agent_port}

# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
RUN mkdir -p $JENKINS_HOME \
  && chown ${uid}:${gid} $JENKINS_HOME \
  && groupadd -g ${gid} ${group} \
  && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME $JENKINS_HOME

# `/usr/share/jenkins/ref/` contains all reference configuration we want
# to set on a fresh new installation. Use it to bundle additional plugins
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d

# Use tini as subreaper in Docker container to adopt zombie processes
ARG TINI_VERSION=v0.16.1
COPY --from=jenkins/jenkins:lts ${JENKINS_HOME}/tini_pub.gpg ${JENKINS_HOME}/tini_pub.gpg
RUN curl -fsSL https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-$(dpkg --print-architecture) -o /sbin/tini \
  && curl -fsSL https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-$(dpkg --print-architecture).asc -o /sbin/tini.asc \
  && gpg --no-tty --import ${JENKINS_HOME}/tini_pub.gpg \
  && gpg --verify /sbin/tini.asc \
  && rm -rf /sbin/tini.asc /root/.gnupg \
  && chmod +x /sbin/tini

#CV jenkins
COPY --from=jenkins/jenkins:lts /usr/share/jenkins/jenkins.war /usr/share/jenkins/jenkins.war

# jenkins version being bundled in this docker image
# ARG JENKINS_VERSION
# ENV JENKINS_VERSION ${JENKINS_VERSION:-2.121.1}
# jenkins.war checksum, download will be validated using it
# ARG JENKINS_SHA=5bb075b81a3929ceada4e960049e37df5f15a1e3cfc9dc24d749858e70b48919

# Can be used to customize where jenkins.war get downloaded from
# ARG JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war

# could use ADD but this one does not check Last-Modified header neither does it allow to control checksum
# see https://github.com/docker/docker/issues/8331
# RUN curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war \
#  && echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha256sum -c -

ENV JENKINS_UC https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals
RUN chown -R ${user} "$JENKINS_HOME" /usr/share/jenkins/ref

# for main web interface:
EXPOSE ${http_port}

# will be used by attached slave agents:
EXPOSE ${agent_port}

ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log

USER ${user}

COPY --from=jenkins/jenkins:lts /usr/local/bin/jenkins-support /usr/local/bin/jenkins-support
COPY jenkins.sh /usr/local/bin/jenkins.sh
COPY --from=jenkins/jenkins:lts /bin/tini /bin/tini
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]

# from a derived Dockerfile, can use `RUN plugins.sh active.txt` to setup /usr/share/jenkins/ref/plugins from a support bundle
COPY --from=jenkins/jenkins:lts /usr/local/bin/plugins.sh /usr/local/bin/plugins.sh
COPY --from=jenkins/jenkins:lts /usr/local/bin/install-plugins.sh /usr/local/bin/install-plugins.sh

USER root

#Add path
ENV PATH ${GRADLE_HOME};${MAVEN_HOME};${PATH}
COPY jenkins.sh /usr/local/bin/jenkins.sh
#RUN apt update && \
#apt -y dist-upgrade && \
#apt -y install \
#    apt-transport-https \
#    ca-certificates \
#    curl \
#    gnupg2 \
#    software-properties-common && \
#curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
#apt-key fingerprint 0EBFCD88 && \
#add-apt-repository \
#   "deb [arch=amd64] https://download.docker.com/linux/debian \
#   $(lsb_release -cs) \
#   stable" && \
#apt update && \
#apt -y install docker-ce && \
#rm -rf /var/lib/apt/lists/* && \
#usermod -aG docker ${user}

USER ${user}
#apk add build-base cmake && \
#apk add wine