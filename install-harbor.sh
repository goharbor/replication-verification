#!/bin/bash
set  -ex

version=${1:-master}

if [ "$version" = "master" ]; then
  wget -Nq https://storage.googleapis.com/harbor-builds/harbor-offline-installer-latest.tgz -O harbor.tgz
else
  wget -Nq https://storage.googleapis.com/harbor-releases/release-${version}/harbor-offline-installer-latest.tgz -O harbor.tgz
fi
