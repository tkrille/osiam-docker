#!/bin/bash

set -e

mv start-tomcat.sh /usr/local/bin/

# setup tomcat
find . -name '*.war' -exec mv {} /var/lib/tomcat7/webapps/ \;
sudo -u tomcat7 -g tomcat7 mkdir /tmp/tomcat7-tomcat7-tmp
sed -i "/^shared\.loader=/c\shared.loader=/var/lib/tomcat7/shared/classes,/var/lib/tomcat7/shared/*.jar,/etc/osiam" /etc/tomcat7/catalina.properties
