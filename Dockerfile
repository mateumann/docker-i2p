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
    org.label-schema.docker.cmd="docker run -d --rm --publish 127.0.0.1:7651:7651 --publish 127.0.0.1:7652:7652 --name i2p mateumann/i2p" \
    org.label-schema.version="0.0.1" \
    org.label-schema.schema-version="1.0"
#    com.microscaling.license="MIT" \

ENV LANG C.UTF-8

#RUN { \
#        echo '#!/bin/sh'; \
#        echo 'set -e'; \
#        echo; \
#        echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
#    } > /usr/local/bin/docker-java-home && \
#    chmod +x /usr/local/bin/docker-java-home

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

COPY i2pinstall* /tmp/
COPY entrypoint.sh /

ENV JAVA_VERSION 8u201
ENV JAVA_ALPINE_VERSION 8.201.08-r1

#    [ "$JAVA_HOME" = "$(docker-java-home)" ] && \
RUN apk --update add --no-cache openjdk8-jre="$JAVA_ALPINE_VERSION" expect && \
    wget http://download.i2p2.no/releases/0.9.39/i2pinstall_0.9.39.jar -O /tmp/i2pinstall_0.9.39.jar && \
    cd /tmp && \
    sha256sum -c /tmp/i2pinstall_0.9.39.jar.sha256 && \
    /tmp/i2pinstall.sh && \
    rm /tmp/i2pinstall_0.9.39.jar /tmp/i2pinstall_0.9.39.jar.sha256 /tmp/i2pinstall.sh && \
    adduser -h /home/i2p -s /bin/ash i2p -D -G daemon && \
    chown -R i2p:daemon /i2p /home/i2p

#RUN echo '@edge http://nl.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories && \
#    echo '@testing http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
#    apk --update add --no-cache i2p@edge tor@testing privoxy@edge runit@testing sudo && \
#    sed "1s/^/SOCKSPort 0.0.0.0:9050\n/; s/^Log\ notice\ .*/Log notice stdout/; s/^DataDirectory.*/DataDirectory \/var\/lib\/tor\/tor.0/; " /etc/tor/torrc.sample > /etc/tor/torrc.0 && \
#    sed "1s/^/SOCKSPort 127.0.0.1:19051\n/; s/^Log\ notice\ .*/Log notice stdout/; s/^DataDirectory.*/DataDirectory \/var\/lib\/tor\/tor.1/; " /etc/tor/torrc.sample > /etc/tor/torrc.1 && \
#    sed "1s/^/SOCKSPort 127.0.0.1:19052\n/; s/^Log\ notice\ .*/Log notice stdout/; s/^DataDirectory.*/DataDirectory \/var\/lib\/tor\/tor.2/; " /etc/tor/torrc.sample > /etc/tor/torrc.2 && \
#    sed "1s/^/SOCKSPort 127.0.0.1:19053\n/; s/^Log\ notice\ .*/Log notice stdout/; s/^DataDirectory.*/DataDirectory \/var\/lib\/tor\/tor.3/; " /etc/tor/torrc.sample > /etc/tor/torrc.3 && \
#    sed "1s/^/SOCKSPort 127.0.0.1:19054\n/; s/^Log\ notice\ .*/Log notice stdout/; s/^DataDirectory.*/DataDirectory \/var\/lib\/tor\/tor.4/; " /etc/tor/torrc.sample > /etc/tor/torrc.4 && \
#    mkdir /var/lib/tor/tor.0 /var/lib/tor/tor.1 /var/lib/tor/tor.2 /var/lib/tor/tor.3 /var/lib/tor/tor.4 && \
#    chown tor -R /etc/service/tor.* /var/lib/tor/ && \
#    chown privoxy -R /etc/service/privoxy.*

EXPOSE 7651 7652

#VOLUME ["/var/lib/tor", "/var/cache/squid"]

#CMD ["runsvdir", "/etc/service"]
CMD ["/entrypoint.sh"]
