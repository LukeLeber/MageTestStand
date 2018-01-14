#!/bin/bash
set -e
set -x
 

function cleanup {
  if [ -z $SKIP_CLEANUP ]; then
    echo "Removing build directory ${BUILDENV}"
    rm -rf "${BUILDENV}"
  fi
}
 
trap cleanup EXIT

# check if this is a travis environment
if [ ! -z $TRAVIS_BUILD_DIR ] ; then
  WORKSPACE=$TRAVIS_BUILD_DIR
fi

if [ -z $WORKSPACE ] ; then
  echo "No workspace configured, please set your WORKSPACE environment"
  exit
fi
 
BUILDENV=`mktemp -d /tmp/mageteststand.XXXXXXXX`
 
echo "Using build directory ${BUILDENV}"
 
git clone https://github.com/LukeLeber/MageTestStand.git "${BUILDENV}"
cp -rf "${WORKSPACE}" "${BUILDENV}/.modman/"
${BUILDENV}/install.sh
if [ -d "${WORKSPACE}/vendor" ] ; then
  cp -rf ${WORKSPACE}/vendor/* "${BUILDENV}/vendor/"
fi
ls -l ${BUILDENV}/htdocs
ls -l ${BUILDENV}/htdocs/app/code/community
ls -l ${BUILDENV}/htdocs/app/code/community/Stabilis
ls -l ${BUILDENV}/htdocs/app/code/community/Stabilis/PaypalExpressRedirect
ls -l ${BUILDENV}/htdocs/app/code/community/Stabilis/PaypalExpressRedirect/Test
ls -l ${BUILDENV}/htdocs/app/code/community/Stabilis/PaypalExpressRedirect/Test/Helper

cat ${BUILDENV}/htdocs/phpunit.xml.dist
cd ${BUILDENV}/htdocs
${BUILDENV}/bin/phpunit --colors -d display_errors=1

