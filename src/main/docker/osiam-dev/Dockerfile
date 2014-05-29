# OSIAM

FROM debian:wheezy
MAINTAINER tarent solutions GmbH <info@tarent.de>

# update/install packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y openjdk-7-jre tomcat7 postgresql-9.1 sudo supervisor postgresql-contrib-9.1
RUN DEBIAN_FRONTEND=noninteractive apt-get clean && apt-get autoclean

# add necessary files to image
ADD supervisord.conf /etc/supervisor/conf.d/osiam.conf
ADD osiam/sql/ /install/sql
ADD osiam/config/ /etc/osiam
ADD osiam/war/ /var/lib/tomcat7/webapps

# install OSIAM
ADD install.sh /install/
RUN chmod a+x /install/install.sh
RUN /install/install.sh
RUN rm -rf /install

# expose postgres and tomcat ports
EXPOSE 5432 8080

# start postgres and tomcat via supervisord
CMD ["/usr/bin/supervisord"]
