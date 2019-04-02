FROM openjdk:8-jdk-stretch
RUN \
apt update && \
apt -y dist-upgrade && \
apt-get install -y git curl \
apt-transport-https \
ca-certificates \
curl \
gnupg2 \
software-properties-common && \
rm -rf /var/lib/apt/lists/*
#Install openj9 for running jenkins
ENV OPENJ9_HOME /opt/java/openj9
COPY --from=adoptopenjdk/openjdk8-openj9:jre /opt/java/openjdk ${OPENJ9_HOME}