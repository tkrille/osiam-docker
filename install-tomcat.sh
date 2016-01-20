#!/bin/bash

set -e

mv start-tomcat.sh /usr/local/bin/

# setup tomcat
find . -name '*.war' -exec mv {} /var/lib/tomcat8/webapps/ \;
sudo -u tomcat8 -g tomcat8 mkdir /tmp/tomcat8-tomcat8-tmp
sed -i "/^shared\.loader=/c\shared.loader=/var/lib/tomcat8/shared/classes,/var/lib/tomcat8/shared/*.jar,/etc/osiam" /etc/tomcat8/catalina.properties
