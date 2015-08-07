#!/usr/bin/env bash
set -e

if [ -n "$DEBUG" ]; then
  DEBUG_COMMAND=jpda
fi

exec sudo -u tomcat7 -g tomcat7 \
    CATALINA_BASE=/var/lib/tomcat7 \
    CATALINA_TMPDIR=/tmp/tomcat7-tomcat7-tmp \
    /usr/share/tomcat7/bin/catalina.sh $DEBUG_COMMAND run

