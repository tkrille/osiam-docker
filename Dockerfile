# OSIAM

FROM debian:wheezy

MAINTAINER tarent solutions GmbH <info@tarent.de>

# update/install packages
RUN echo 'force-unsafe-io' | tee /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    echo 'DPkg::Post-Invoke {"/bin/rm -f /var/cache/apt/archives/*.deb || true";};' | tee /etc/apt/apt.conf.d/no-cache && \
    DEBIAN_FRONTEND=noninteractive apt-get update -y && apt-get dist-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        openjdk-7-jre tomcat7 postgresql-9.1 sudo curl supervisor postgresql-contrib-9.1 && \
    apt-get clean && rm -rf /var/cache/apt/*

# install OSIAM
ADD . /install
RUN /install/install.sh

# expose postgres and tomcat ports
EXPOSE 5432 8080

# start postgres and tomcat via supervisord
CMD ["/usr/bin/supervisord"]
