#!/bin/bash
set -ex

TOPDIR=$(realpath $(dirname $(realpath $0))/..)

echo $TOPDIR

pushd $TOPDIR

PACKAGE_NAME=doxymacs
VERSION=$(git describe --tags)
VERSION=${VERSION#v}

WORKDIR="${TOPDIR}/${PACKAGE_NAME}_${VERSION}"


mkdir $WORKDIR/DEBIAN -p
mkdir $WORKDIR/usr/local -p

cat <<EOF > $WORKDIR/DEBIAN/control
Package: ${PACKAGE_NAME}
Version: ${VERSION}
Section: custom
Priority: optional
Architecture: amd64
Essential: no
Depends: libxml2
Maintainer: Janncker
Description: packaged for ubuntu

EOF

cp ${TOPDIR}/package/postinst $WORKDIR/DEBIAN/
chmod a+x ${WORKDIR}/DEBIAN/postinst
./bootstrap
./configure --prefix=$WORKDIR/usr/local

make install -j $(nproc)

cd ${WORKDIR}

dpkg-deb --build $WORKDIR

popd
