# syntax=docker/dockerfile:1.0-experimental
FROM alpine:3.12

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="mateumann@gmail.com" \
    org.label-schema.name="i2p" \
    org.label-schema.description="I2P Network Client/Proxy" \
    org.label-schema.usage="/LICENSE" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-url="https://github.com/mateumann/docker-i2p.git" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.version="0.4.0" \
    org.label-schema.schema-version="1.0" \
    com.microscaling.license="MIT"

ENV LANG C
ENV LC_ALL C

COPY i2pinstall* /tmp/
COPY entrypoint.sh /

WORKDIR /i2p

RUN apk --update add --no-cache openjdk8-jre=8.252.09-r0 expect=5.45.4-r0 && \
    rm -rf /var/cache/apk/* && \
    wget --no-check-certificate https://download.i2p2.de/releases/0.9.47/i2pinstall_0.9.47.jar -O /tmp/i2pinstall_0.9.47.jar && \
    ls -l /tmp/ && \
    sha256sum -c /tmp/i2pinstall_0.9.47.jar.sha256 && \
    /tmp/i2pinstall.sh && \
    rm /tmp/i2pinstall_0.9.47.jar /tmp/i2pinstall_0.9.47.jar.sha256 /tmp/i2pinstall.sh && \
    cp /i2p/runplain.sh /i2p/runplain.sh.orig && \
    sed "s/%SYSTEM_java_io_tmpdir/\/var\/tmp/" /i2p/runplain.sh.orig > /i2p/runplain.sh && \
    mv /i2p/clients.config /i2p/clients.config.orig && \
    mv /i2p/i2ptunnel.config /i2p/i2ptunnel.config.orig && \
    sed "s/^clientApp\.0\.args=7657/#clientApp.0.args=7657/; s/^#clientApp.0.args=7657 0\.0\.0\.0/clientApp.0.args=7657 0.0.0.0/" /i2p/clients.config.orig > /i2p/clients.config && \
    sed "s/^tunnel\.\(.\)\.interface=127.0.0.1/tunnel.\1.interface=0.0.0.0/" /i2p/i2ptunnel.config.orig > /i2p/i2ptunnel.config && \
    adduser -h /home/i2p -s /bin/ash i2p -D -G daemon && \
    chown -R i2p:daemon /i2p /home/i2p

USER i2p

EXPOSE 4444 4445 7657 7658

VOLUME ["/home/i2p"]

ENTRYPOINT ["/entrypoint.sh"]
