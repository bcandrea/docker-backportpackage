#!/bin/bash
set -e

build () {
  echo "Backporting package $package from $source_distro to $target_distro"
  cowbuilder --create --distribution $target_distro --components "main restricted universe multiverse" \
    --basepath=/var/lib/pbuilder/$target_distro-base.cow
  BASEPATH=/var/lib/pbuilder/$target_distro-base.cow \
    backportpackage -B cowbuilder -b -s $source_distro -d $target_distro -w /var/lib/backports $package
}

upload () {
  echo "Uploading backported package $package [$source_distro -> $target_distro] to $ppa"
  backportpackage -s $source_distro -d $target_distro -u $ppa $package
}

check_env () {
  for var in $@; do
    missing=0
    env | grep -q "$var=" || missing=1
    if [ $missing -eq 1 ]; then
      echo "Please set the environment variable $var"
      exit 1
    fi
  done
}

update_debsign_keyid () {
  echo "DEBSIGN_KEYID=$DEBSIGN_KEYID" >> /etc/devscripts.conf
}

if [ $# -lt 3 ]; then
  echo "usage: backportpackage.sh <package> <source distro> <target distro> [<ppa>]"
  exit 1
fi

package=$1
shift
source_distro=$1
shift
target_distro=$1
shift
ppa=$1

check_env DEBFULLNAME DEBEMAIL DEBSIGN_KEYID
update_debsign_keyid

if [ "_$ppa" = "_" ]; then
  build
else
  upload
fi
