#!/bin/bash

set -e

cd /install

./install-3rdparty.sh
./install-build.sh
./install-configuration.sh
./install-database.sh
./install-tomcat.sh
./install-cleanup.sh
