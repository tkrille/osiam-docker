# OSIAM

FROM debian:wheezy

MAINTAINER tarent solutions GmbH <info@tarent.de>

# update/install packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y --force-yes && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y --force-yes \
        openjdk-7-jdk tomcat7 postgresql-9.1 sudo curl supervisor unzip vim-tiny less git

# install OSIAM
COPY . /install/
RUN /install/install.sh

# expose postgres, tomcat and pop3 ports
EXPOSE 5432 8080 10110

# start postgres and tomcat via supervisord
CMD ["/usr/bin/supervisord"]
