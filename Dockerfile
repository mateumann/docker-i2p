FROM alpine:edge

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="mateumann@gmail.com" \
    org.label-schema.namei2p \
    org.label-schema.description="I2P Network Client/Proxy" \
    org.label-schema.usage="/LICENSE" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-url="https://github.com/mateumann/docker-i2p.git" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.docker.cmd="docker run -d --rm --publish 127.0.0.1:4444:4444 --publish 127.0.0.1:4445:4445 --name i2p mateumann/i2p" \
    org.label-schema.version="0.0.1" \
    org.label-schema.schema-version="1.0"
#    com.microscaling.license="MIT" \

COPY services /etc/service

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

EXPOSE 4444 4445

#VOLUME ["/var/lib/tor", "/var/cache/squid"]

#CMD ["runsvdir", "/etc/service"]
