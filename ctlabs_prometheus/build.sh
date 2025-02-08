#!/bin/bash

# ------------------------------------------------------------------------------
# SOURCES
# ------------------------------------------------------------------------------
VERSION=3.1.0
NAME=prometheus

SRC_TAR=${NAME}-${VERSION}.linux-amd64.tar.gz
SRC_URL="https://github.com/prometheus/${NAME}/releases/download/v${VERSION}/${NAME}-${VERSION}.linux-amd64.tar.gz"

# ------------------------------------------------------------------------------
# Package Attributes
# ------------------------------------------------------------------------------
DESC="The Prometheus monitoring system and time series database"
URL=https://github.com/prometheus/prometheus
PKG_NAME=ctlabs_${NAME}
RPM_NAME=ctlabs_${NAME}-${VERSION}.rpm
DEPS=()

# ------------------------------------------------------------------------------
# Build Details
# ------------------------------------------------------------------------------
BINARY=${NAME}
SRCDIR=${NAME}-${VERSION}.linux-amd64
DSTDIR=/opt/${NAME}-${VERSION}

# ------------------------------------------------------------------------------
# Build Functions
# ------------------------------------------------------------------------------
prepare() {
  mkdir -vp /tmp/${NAME}
  cd /tmp/${NAME} && curl -sLO ${SRC_URL} && tar xvf ${SRC_TAR}
  cd -
}

build() {
  #cd /tmp/${NAME}/${SRCDIR}   &&
  ln -sv ${DSTDIR}/${BINARY} /tmp/${NAME}/${SRCDIR}/${NAME}_LINK
  ln -sv ${DSTDIR}/promtool  /tmp/${NAME}/${SRCDIR}/promtool_LINK

  fpm -s dir                  \
      -t rpm                  \
      -p ${RPM_NAME}          \
      -n ${PKG_NAME}          \
      -v ${VERSION}           \
      -a amd64                \
      --url ${URL}            \
      --description "${DESC}" \
      /tmp/${NAME}/${SRCDIR}/${BINARY}=${DSTDIR}/${BINARY}   \
      /tmp/${NAME}/${SRCDIR}/${NAME}_LINK=/usr/bin/${BINARY} \
      /tmp/${NAME}/${SRCDIR}/${BINARY}=${DSTDIR}/promtool    \
      /tmp/${NAME}/${SRCDIR}/promtool_LINK=/usr/bin/promtool
}

cleanup() {
  rm -rf /tmp/${NAME}
}

prepare
build
cleanup
