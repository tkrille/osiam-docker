#!/usr/bin/env bash
set -e

if [ -n "$DEBUG" ]; then
  DEBUG_COMMAND=jpda
fi

exec sudo -u tomcat8 -g tomcat8 \
    CATALINA_BASE=/var/lib/tomcat8 \
    CATALINA_TMPDIR=/tmp/tomcat8-tomcat8-tmp \
    CATALINA_OPTS="-Djava.awt.headless=true -Xms512m -Xmx2048m -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:+CMSPermGenSweepingEnabled -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=1024m" \
    JPDA_ADDRESS=8000 \
    /usr/share/tomcat8/bin/catalina.sh $DEBUG_COMMAND run
