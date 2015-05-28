#!/bin/bash

INSTALLER_DIR=/install

# install flyway
curl -o $INSTALLER_DIR/flyway.tgz http://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/3.2.1/flyway-commandline-3.2.1.tar.gz
tar -C $INSTALLER_DIR/ -xzf $INSTALLER_DIR/flyway.tgz
mv $INSTALLER_DIR/flyway-3.2.1 /opt/flyway
mv -f $INSTALLER_DIR/flyway.conf /opt/flyway/conf/flyway.conf
chmod +x /opt/flyway/flyway
ln -s /opt/flyway/flyway /usr/local/bin/flyway

# install greenmail webapp to provide simple smtp service for the self-administration and administration
curl -o $INSTALLER_DIR/greenmail.war http://central.maven.org/maven2/com/icegreen/greenmail-webapp/1.4.1/greenmail-webapp-1.4.1.war
unzip $INSTALLER_DIR/greenmail.war -d /var/lib/tomcat7/webapps/greenmail
sed -i 's/127.0.0.1/0.0.0.0/g' /var/lib/tomcat7/webapps/greenmail/WEB-INF/web.xml

. $INSTALLER_DIR/build.conf

OSIAM_DIST_DIR="$INSTALLER_DIR/osiam-distribution-$OSIAM_VERSION"

# download osiam and prepare for installation
# mvn initialize
curl -o $INSTALLER_DIR/osiam-dist.tgz \
    https://maven-repo.evolvis.org/releases/org/osiam/osiam-distribution/$OSIAM_VERSION/osiam-distribution-$OSIAM_VERSION.tar.gz
tar -C $INSTALLER_DIR/ -xzf $INSTALLER_DIR/osiam-dist.tgz

# add configs
mkdir /etc/osiam
mv $OSIAM_DIST_DIR/osiam-server/osiam-resource-server/configuration/* /etc/osiam
mv $OSIAM_DIST_DIR/osiam-server/osiam-auth-server/configuration/* /etc/osiam
mv $OSIAM_DIST_DIR/addon-self-administration/configuration/* /etc/osiam
mv $OSIAM_DIST_DIR/addon-administration/configuration/* /etc/osiam

sed -i 's/org.osiam.mail.server.smtp.port=25/org.osiam.mail.server.smtp.port=10025/g' /etc/osiam/addon-self-administration.properties
sed -i 's/your.smtp.server.com/localhost/g' /etc/osiam/addon-self-administration.properties
sed -i 's/org.osiam.mail.server.username=username/org.osiam.mail.server.username=user1/g' /etc/osiam/addon-self-administration.properties

sed -i 's/org.osiam.mail.server.smtp.port=25/org.osiam.mail.server.smtp.port=10025/g' /etc/osiam/addon-administration.properties
sed -i 's/your.smtp.server.com/localhost/g' /etc/osiam/addon-administration.properties
sed -i 's/org.osiam.mail.server.username=username/org.osiam.mail.server.username=user1/g' /etc/osiam/addon-administration.properties

mv $INSTALLER_DIR/supervisord.conf /etc/supervisor/conf.d/osiam.conf

# setup database
useradd -M -s /bin/false -U ong
echo "local all all           md5" >> /etc/postgresql/9.1/main/pg_hba.conf
echo "host  all all 0.0.0.0/0 md5" >> /etc/postgresql/9.1/main/pg_hba.conf
echo "listen_addresses='*'" >> /etc/postgresql/9.1/main/postgresql.conf
rm -f /var/lib/postgresql/9.1/main/server.crt
cp /etc/ssl/certs/ssl-cert-snakeoil.pem /var/lib/postgresql/9.1/main/server.crt
rm -f /var/lib/postgresql/9.1/main/server.key
cp /etc/ssl/private/ssl-cert-snakeoil.key /var/lib/postgresql/9.1/main/server.key
chown postgres:postgres /var/lib/postgresql/9.1/main/server.crt /var/lib/postgresql/9.1/main/server.key

/etc/init.d/postgresql start

echo "CREATE USER ong WITH PASSWORD 'b4s3dg0d';" | sudo -u postgres psql
echo "CREATE DATABASE ong;" | sudo -u postgres psql
echo "GRANT ALL PRIVILEGES ON DATABASE ong TO ong;" | sudo -u postgres psql

mkdir -p migrations/auth-server
unzip -joqq $OSIAM_DIST_DIR/osiam-server/osiam-auth-server/osiam-auth-server.war 'WEB-INF/classes/db/migration/postgresql/*' -d migrations/auth-server
flyway -table=auth_server_schema_version -locations=filesystem:migrations/auth-server migrate

mkdir -p migrations/resource-server
unzip -joqq $OSIAM_DIST_DIR/osiam-server/osiam-resource-server/osiam-resource-server.war 'WEB-INF/classes/db/migration/postgresql/*' -d migrations/resource-server
flyway -table=resource_server_schema_version -locations=filesystem:migrations/resource-server migrate

# import setup data
sudo -u ong psql -f $OSIAM_DIST_DIR/addon-self-administration/sql/init_data.sql
sudo -u ong psql -f $INSTALLER_DIR/setup_data.sql

# setup tomcat
find $OSIAM_DIST_DIR -name '*.war' -exec mv {} /var/lib/tomcat7/webapps/ \;
sudo -u tomcat7 -g tomcat7 mkdir /tmp/tomcat7-tomcat7-tmp
sed -i "/^shared\.loader=/c\shared.loader=/var/lib/tomcat7/shared/classes,/var/lib/tomcat7/shared/*.jar,/etc/osiam" /etc/tomcat7/catalina.properties
sed -i "/^JAVA_OPTS=/c\JAVA_OPTS=\"-Djava.awt.headless=true -Xms512m -Xmx1024m -XX:+UseConcMarkSweepGC\"" /etc/default/tomcat7

# cleanup
rm -rf $INSTALLER_DIR
