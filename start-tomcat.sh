#!/usr/bin/env bash
set -e

if [ -n "$DEBUG" ]; then
  DEBUG_COMMAND=jpda
fi

exec sudo -u tomcat7 -g tomcat7 \
    CATALINA_BASE=/var/lib/tomcat7 \
    CATALINA_TMPDIR=/tmp/tomcat7-tomcat7-tmp \
    CATALINA_OPTS="-Djava.awt.headless=true -Xms512m -Xmx2048m -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:+CMSPermGenSweepingEnabled -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=1024m" \
    /usr/share/tomcat7/bin/catalina.sh $DEBUG_COMMAND run
