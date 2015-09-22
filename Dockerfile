FROM digitalrebar/base
MAINTAINER Victor Lowther <victor@rackn.com>

ENV SQUID_VERSION=3.3.8 \
    SQUID_CACHE_DIR=/var/spool/squid3 \
    SQUID_LOG_DIR=/var/log/squid3 \
    SQUID_USER=proxy

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 80F70E11F0F0D5F10CB20E62F5DA5F09C3173AA6 \
 && echo "deb http://ppa.launchpad.net/brightbox/squid-ssl/ubuntu trusty main" >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y squid3-ssl=${SQUID_VERSION}* \
 && mv /etc/squid3/squid.conf /etc/squid3/squid.conf.dist \
 && rm -rf /var/lib/apt/lists/*

COPY squid.conf /etc/squid3/squid.conf
COPY entrypoint.d/*.sh /usr/local/entrypoint.d/
COPY squid.json /etc/consul.d/squid.json

VOLUME ["${SQUID_CACHE_DIR}"]
ENTRYPOINT ["/sbin/docker-entrypoint.sh"]
