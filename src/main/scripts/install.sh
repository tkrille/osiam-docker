#!/bin/bash

useradd -M -s /bin/false -U ong
echo "local all all           md5" >> /etc/postgresql/9.1/main/pg_hba.conf
echo "host  all all 0.0.0.0/0 md5" >> /etc/postgresql/9.1/main/pg_hba.conf
echo "listen_addresses='*'" >> /etc/postgresql/9.1/main/postgresql.conf

/etc/init.d/postgresql start

echo "CREATE USER ong WITH PASSWORD 'b4s3dg0d';" | sudo -u postgres psql
echo "CREATE DATABASE ong;" | sudo -u postgres psql
echo "GRANT ALL PRIVILEGES ON DATABASE ong TO ong;" | sudo -u postgres psql

sudo -u ong psql -f /install/sql/auth-server/drop_all.sql -U ong
sudo -u ong psql -f /install/sql/auth-server/init_ddl.sql -U ong
sudo -u ong psql -f /install/sql/auth-server/example_data.sql -U ong

sudo -u ong psql -f /install/sql/resource-server/drop_all.sql -U ong
sudo -u ong psql -f /install/sql/resource-server/init_ddl.sql -U ong
sudo -u ong psql -f /install/sql/resource-server/init_data.sql -U ong
sudo -u ong psql -f /install/sql/resource-server/example_data.sql -U ong

sudo -u ong psql -f /install/sql/addon-self-administration/init_data.sql -U ong

sudo -u tomcat7 -g tomcat7 mkdir /tmp/tomcat7-tomcat7-tmp
sed -i "/^shared\.loader=/c\shared.loader=/var/lib/tomcat7/shared/classes,/var/lib/tomcat7/shared/*.jar,/etc/osiam" /etc/tomcat7/catalina.properties
sed -i "/^JAVA_OPTS=/c\JAVA_OPTS=\"-Djava.awt.headless=true -Xms512m -Xmx1024m -XX:+UseConcMarkSweepGC\"" /etc/default/tomcat7