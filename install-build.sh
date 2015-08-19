#!/bin/bash

set -e

. build.conf

git clone ${OSIAM_AUTH_SERVER_REPO} auth-server
pushd auth-server
git checkout ${OSIAM_AUTH_SERVER_REF}
mvn package -DskipTests
popd

git clone ${OSIAM_RESOURCE_SERVER_REPO} resource-server
pushd resource-server
git checkout ${OSIAM_RESOURCE_SERVER_REF}
mvn package -DskipTests
popd

git clone ${OSIAM_ADDON_SELF_ADMINISTRATION_REPO} addon-self-administration
pushd addon-self-administration
git checkout ${OSIAM_ADDON_SELF_ADMINISTRATION_REF}
mvn package -DskipTests
popd

git clone ${OSIAM_ADDON_ADMINISTRATION_REPO} addon-administration
pushd addon-administration
git checkout ${OSIAM_ADDON_ADMINISTRATION_REF}
mvn package -DskipTests
popd
