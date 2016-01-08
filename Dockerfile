FROM linuxserver/baseimage

MAINTAINER Sparklyballs <sparklyballs@linuxserver.io>

ENV APTLIST="git-core libwxgtk2.8-dev libgd2-xpm-dev libreadline-dev libgeoip-dev \
debhelper libupnp-dev binutils-dev libqt4-dev kdelibs5-dev bison flex build-essential \
libglib2.0-dev libgtk2.0-dev libcrypto++-dev autoconf gettext autopoint"

# install packages
RUN apt-get update -q && \
apt-get install $APTLIST -qy && \
git clone https://github.com/amule-project/amule /tmp/amule && \
cd /tmp/amule && \
dpkg-buildpackage -us -uc -b -rfakeroot && \
cd / && \

# cleanup
apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# add Custom files
# ADD defaults/ /defaults/
# ADD init/ /etc/my_init.d/
# ADD services/ /etc/service/
RUN chmod -v +x /etc/service/*/run /etc/my_init.d/*.sh

# volumes and ports
VOLUME /config /downloads
EXPOSE 4711/tcp 4712/tcp 4672/udp 4665/udp 4662/tcp 4661/tcp

