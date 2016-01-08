FROM linuxserver/baseimage

MAINTAINER Sparklyballs <sparklyballs@linuxserver.io>

ENV APTLIST="autoconf git-core zlib1g-dev build-essential libwxgtk3.0-dev libcrypto++-dev ibgtk2.0-dev libupnp6-dev"

# install packages
RUN apt-get update -q && \
apt-get install $APTLIST -qy && \
curl -o /tmp/boost.tar.gz -L http://sourceforge.net/projects/boost/files/boost/1.60.0/boost_1_60_0.tar.bz2/download && \
mkdir -p /tmp/boostsource && \
tar xvf /tmp/boost.tar.gz -C /tmp/boostsource --strip-components=1 && \
git clone https://github.com/amule-project/amule /tmp/amule && \
cd /tmp/amule && \
automake && \
autoconf && \
./configure --disable-debug --enable-optimize --with-denoise-level=3 --enable-upnp --enable-geoip --enable-nls --enable-amule-gui --enable-amule-daemon --enable-amulecmd --enable-webserver --enable-alcc --enable-alc --enable-cas --enable-wxcas --enable-mmap --with-boost=/tmp/boostsource && \
make && \
make install && \
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

