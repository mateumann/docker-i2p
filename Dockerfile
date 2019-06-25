# syntax=docker/dockerfile:1.0-experimental
FROM alpine:3.10.0

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="mateumann@gmail.com" \
    org.label-schema.name="i2p" \
    org.label-schema.description="I2P Network Client/Proxy" \
    org.label-schema.usage="/LICENSE" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-url="https://github.com/mateumann/docker-i2p.git" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.version="0.2.0" \
    org.label-schema.schema-version="1.0" \
    com.microscaling.license="MIT"

ENV LANG C.UTF-8

COPY i2pinstall* /tmp/
COPY entrypoint.sh /

WORKDIR /tmp
RUN apk --update add --no-cache openjdk8-jre=8.212.04-r0 expect=5.45.4-r0 && \
    rm -rf /var/cache/apk/* && \
    wget http://download.i2p2.no/releases/0.9.40/i2pinstall_0.9.40.jar -O /tmp/i2pinstall_0.9.40.jar && \
    sha256sum -c /tmp/i2pinstall_0.9.40.jar.sha256 && \
    /tmp/i2pinstall.sh && \
    rm /tmp/i2pinstall_0.9.40.jar /tmp/i2pinstall_0.9.40.jar.sha256 /tmp/i2pinstall.sh && \
    mv /i2p/clients.config /i2p/clients.config.orig && \
    sed "s/^clientApp\.0\.args=7657/#clientApp.0.args=7657/; s/^#clientApp.0.args=7657 0\.0\.0\.0/clientApp.0.args=7657 0.0.0.0/; " /i2p/clients.config.orig > /i2p/clients.config && \
    adduser -h /home/i2p -s /bin/ash i2p -D -G daemon && \
    chown -R i2p:daemon /i2p /home/i2p

EXPOSE 4444 4445 7657

VOLUME ["/home/i2p"]

ENTRYPOINT ["/entrypoint.sh"]
