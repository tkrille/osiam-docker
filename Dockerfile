# OSIAM

FROM debian:wheezy

MAINTAINER tarent solutions GmbH <info@tarent.de>

# update/install packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && apt-get dist-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        openjdk-7-jre-headless tomcat7 postgresql-9.1 sudo curl supervisor postgresql-contrib-9.1

# install OSIAM
ADD . /install
RUN /install/install.sh

# expose postgres and tomcat ports
EXPOSE 5432 8080

# start postgres and tomcat via supervisord
CMD ["/usr/bin/supervisord"]
