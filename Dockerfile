# OSIAM

FROM debian:wheezy

MAINTAINER tarent solutions GmbH <info@tarent.de>

# update/install packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && apt-get dist-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        openjdk-7-jre-headless tomcat7 postgresql-9.1 sudo curl supervisor unzip nvi less

# install OSIAM
COPY addon-self-administration.properties build.conf flyway.conf install.sh supervisord.conf /install/
RUN /install/install.sh

COPY start-tomcat.sh /usr/local/bin/

# expose postgres and tomcat ports
EXPOSE 5432 8080 10110

# start postgres and tomcat via supervisord
CMD ["/usr/bin/supervisord"]
