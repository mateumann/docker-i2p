FROM alpine:edge

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="mateumann@gmail.com" \
    org.label-schema.name="i2p" \
    org.label-schema.description="I2P Network Client/Proxy" \
    org.label-schema.usage="/LICENSE" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-url="https://github.com/mateumann/docker-i2p.git" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.docker.cmd="docker run -d --rm --publish 127.0.0.1:7657:7657 --name i2p mateumann/i2p" \
    org.label-schema.version="0.0.1" \
    org.label-schema.schema-version="1.0"
#    com.microscaling.license="MIT" \

ENV LANG C.UTF-8

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

COPY i2pinstall* /tmp/
COPY entrypoint.sh /

ENV JAVA_VERSION 8u201
ENV JAVA_ALPINE_VERSION 8.201.08-r1

RUN apk --update add --no-cache openjdk8-jre="$JAVA_ALPINE_VERSION" expect && \
    wget http://download.i2p2.no/releases/0.9.39/i2pinstall_0.9.39.jar -O /tmp/i2pinstall_0.9.39.jar && \
    cd /tmp && \
    sha256sum -c /tmp/i2pinstall_0.9.39.jar.sha256 && \
    /tmp/i2pinstall.sh && \
    rm /tmp/i2pinstall_0.9.39.jar /tmp/i2pinstall_0.9.39.jar.sha256 /tmp/i2pinstall.sh && \
    mv /i2p/clients.config /i2p/clients.config.orig && \
    sed "s/^clientApp\.0\.args=7657/#clientApp.0.args=7657/; s/^#clientApp.0.args=7657 0\.0\.0\.0/clientApp.0.args=7657 0.0.0.0/; " /i2p/clients.config.orig > /i2p/clients.config && \
    adduser -h /home/i2p -s /bin/ash i2p -D -G daemon && \
    chown -R i2p:daemon /i2p /home/i2p

EXPOSE 7657

VOLUME ["/i2p"]

CMD ["/entrypoint.sh"]
