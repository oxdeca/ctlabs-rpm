#!/bin/bash

# ------------------------------------------------------------------------------
# SOURCES
# ------------------------------------------------------------------------------
VERSION=2.4.0
NAME=termshark

SRC_TAR=${NAME}_${VERSION}_linux_x64.tar.gz
SRC_URL=https://github.com/gcla/termshark/releases/download/v${VERSION}/${SRC_TAR}

# ------------------------------------------------------------------------------
# Package Attributes
# ------------------------------------------------------------------------------
DESC="A terminal user-interface for tshark"
URL=https://github.com/gcla/termshark/
PKG_NAME=ctlabs_${NAME}
RPM_NAME=ctlabs_${NAME}-${VERSION}.rpm
DEPS=( 'wireshark-cli' )

# ------------------------------------------------------------------------------
# Build Details
# ------------------------------------------------------------------------------
BINARY=${NAME}
SRCDIR=${NAME}_${VERSION}_linux_x64
DSTDIR=/opt/${NAME}-${VERSION}

# ------------------------------------------------------------------------------
# Build Functions
# ------------------------------------------------------------------------------
prepare() {
  mkdir /tmp/${NAME}
  cd /tmp/${NAME} && curl -sLO ${SRC_URL} && tar xvf ${SRC_TAR}
  cd -
}

build() {
  #cd /tmp/${NAME}/${SRCDIR}   &&
  ln -sv ${DSTDIR}/${BINARY} /tmp/${NAME}/${SRCDIR}/${NAME}_LINK

  fpm -s dir                  \
      -t rpm                  \
      -p ${RPM_NAME}          \
      -n ${PKG_NAME}          \
      -v ${VERSION}           \
      -a all                  \
      -d wireshark-cli        \
      --url ${URL}            \
      --description "${DESC}" \
      /tmp/${NAME}/${SRCDIR}/${BINARY}=${DSTDIR}/${BINARY} \
      /tmp/${NAME}/${SRCDIR}/${NAME}_LINK=/usr/bin/${BINARY}
}

cleanup() {
  rm -rf /tmp/${NAME}
}

prepare
build
cleanup
