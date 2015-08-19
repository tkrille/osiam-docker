#!/bin/bash

set -e

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
cp auth-server/target/osiam-auth-server-classes.jar migrations/auth-server
flyway -table=auth_server_schema_version \
    -locations=db/migration/postgresql/ \
    -jarDirs=./migrations/auth-server \
    migrate

mkdir -p migrations/resource-server
cp resource-server/target/osiam-resource-server-classes.jar migrations/resource-server
flyway -table=resource_server_schema_version \
    -locations=db/migration/postgresql/ \
    -jarDirs=./migrations/resource-server \
    migrate

# import addon setup data
sudo -u ong psql -f addon-self-administration/src/main/sql/client.sql
sudo -u ong psql -f addon-self-administration/src/main/sql/extension.sql
sudo -u ong psql -f addon-administration/src/main/sql/client.sql
sudo -u ong psql -f addon-administration/src/main/sql/admin_group.sql
