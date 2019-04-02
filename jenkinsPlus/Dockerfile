FROM jenkins/jenkins:lts
USER root
#Install maven
ENV MAVEN_VERSION 3.6.0
ENV MAVEN_HOME /usr/share/maven
COPY --from=maven:3.6-jdk-8-alpine /usr/share/maven ${MAVEN_HOME}

#Install gradle
ENV GRADLE_VERSION 5.3.1
ENV GRADLE_HOME /usr/share/gradle
COPY --from=gradle:5.3.1-jre8-alpine /opt/gradle ${GRADLE_HOME}

#Install openj9 for running jenkins
ENV OPENJ9_HOME /opt/java/openj9
COPY --from=adoptopenjdk/openjdk8-openj9 /opt/java/openjdk ${OPENJ9_HOME}
#COPY --from=adoptopenjdk/openjdk8-openj9:alpine-jre /usr/glibc-compat/lib /usr/glibc-compat/lib
#Install golang
# ENV GOLANG_VERSION 1.12.1
# ENV GOPATH /usr/share/go
# COPY --from=golang:1.12.1-alpine3.9 /go ${GOPATH}
# ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
#Set user and reset jenkins.sh
#RUN rm /usr/local/bin/jenkins.sh
ENV PATH ${GRADLE_HOME};${MAVEN_HOME};
COPY jenkins.sh /usr/local/bin/jenkins.sh
RUN \
apt update &&\
apt -y dist-upgrade &&\
apt -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common && \
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
apt-key fingerprint 0EBFCD88 && \
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable" && \
apt update && \
apt -y install docker-ce-cli && \
rm -rf /var/lib/apt/lists/*
USER jenkins
#apk add build-base cmake && \
#apk add wine