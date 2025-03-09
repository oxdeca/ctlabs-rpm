#!/bin/bash

# ------------------------------------------------------------------------------
# SOURCES
# ------------------------------------------------------------------------------
VERSION=1.5.0
NAME=agg

SRC_TAR=${NAME}-${VERSION}.linux-amd64.tar.gz
SRC_URL="https://github.com/asciinema/${NAME}/releases/download/v${VERSION}/${NAME}-x86_64-unknown-linux-gnu"
GIT_URL="https://github.com/asciinema/agg"

# ------------------------------------------------------------------------------
# Package Attributes
# ------------------------------------------------------------------------------
PKG_DESC="asciinema gif generator"
PKG_URL=https://github.com/asciinema/agg
PKG_NAME=ctlabs_${NAME}
PKG_FILE=ctlabs_${NAME}-${VERSION}.rpm

# ------------------------------------------------------------------------------
# Build Details
# ------------------------------------------------------------------------------
BASE_DIR=/tmp/${NAME}
BUILD_DIR=${BASE_DIR}/BUILD
SOURCE_DIR=${BASE_DIR}/SOURCE
RPM_DIR=${BASE_DIR}/RPMS
BUILD_DEPS=('cargo')
DSTDIR=/opt/${NAME}-${VERSION}

# ------------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------------
pre_build() {
  mkdir -vp ${SOURCE_DIR}
  mkdir -vp ${BUILD_DIR}
  mkdir -vp ${RPM_DIR}

  cd ${SOURCE_DIR}
  git clone ${GIT_URL}
}

build_deps() {
  for pkg in ${BUILD_DEPS[@]}; do
    dnf install -y $pkg
  done
}

build() {
  cd ${SOURCE_DIR}/agg
  cargo build --release
  install -D ./target/release/agg ${BUILD_DIR}/usr/bin/agg
}

package() {
  fpm -s dir                      \
      -t rpm                      \
      -p ${RPM_DIR}/${PKG_FILE}   \
      -n ${PKG_NAME}              \
      -v ${VERSION}               \
      -a amd64                    \
      --url ${PKG_URL}            \
      --description "${PKG_DESC}" \
      -C ${BUILD_DIR}             \
      .
}

cleanup() {
  rm -rf ${SOURCE_DIR} ${BUILD_DIR}
}

pre_build
build_deps
build
package
cleanup
