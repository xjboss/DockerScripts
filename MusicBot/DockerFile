FROM adoptopenjdk/openjdk8-openj9:alpine-nightly

ARG user=MusicBot
ARG group=MusicBot
ARG uid=666
ARG gid=666
ENV BOT_HOME=/home/MusicBot
ENV BOT_APPPATH=/usr/share/MusicBot
ARG bot_version=0.2.2
RUN \
mkdir -p ${BOT_HOME} && \
chown ${uid}:${gid} ${BOT_HOME} && \
addgroup -g ${gid} ${group} && \
adduser -h "${BOT_HOME}" -u ${uid} -G ${group} -s /bin/bash -D ${user}

RUN \
apk add bash && \
apk add --virtual .fetch-deps curl && \
mkdir -p ${BOT_APPPATH} && \
cd ${BOT_APPPATH} && \
curl -fsSL https://github.com/jagrosh/MusicBot/releases/download/${bot_version}/JMusicBot-${bot_version}-Linux.jar -o JMusicBot.jar && \
chmod 755 JMusicBot.jar && \
apk del --purge .fetch-deps && \
rm -rf /var/cache/apk/*
VOLUME $BOT_HOME
ENV JAVA_OPS=-Dnogui=true
ENV JMUSICBOT_APP=${BOT_APPPATH}/JMusicBot.jar
COPY start_nm\$l.sh ${BOT_APPPATH}/start.sh
USER MusicBot
WORKDIR $BOT_HOME
ENTRYPOINT ["/bin/bash", "/usr/share/MusicBot/start.sh"]