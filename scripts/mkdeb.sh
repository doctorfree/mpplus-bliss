#!/bin/bash
PKG="mpplus-bliss"
SRC_NAME="mpplus-bliss"
PKG_NAME="mpplus-bliss"
DEBFULLNAME="Ronald Record"
DEBEMAIL="ronaldrecord@gmail.com"
DESTDIR="usr"
SRC=${HOME}/src
ARCH=amd64
SUDO=sudo
GCI=

dpkg=`type -p dpkg-deb`
[ "${dpkg}" ] || {
    echo "Debian packaging tools do not appear to be installed on this system"
    echo "Are you on the appropriate Linux system with packaging requirements ?"
    echo "Exiting"
    exit 1
}
dpkg_arch=`dpkg --print-architecture`
[ "${dpkg_arch}" == "${ARCH}" ] || ARCH=${dpkg_arch}

[ -f "${SRC}/${SRC_NAME}/VERSION" ] || {
  [ -f "/builds/doctorfree/${SRC_NAME}/VERSION" ] || {
    echo "$SRC/$SRC_NAME/VERSION does not exist. Exiting."
    exit 1
  }
  SRC="/builds/doctorfree"
  GCI=1
# SUDO=
}

. "${SRC}/${SRC_NAME}/VERSION"
PKG_VER=${VERSION}
PKG_REL=${RELEASE}

umask 0022

# Subdirectory in which to create the distribution files
OUT_DIR="dist/${PKG_NAME}_${PKG_VER}"

[ -d "${SRC}/${SRC_NAME}" ] || {
    echo "$SRC/$SRC_NAME does not exist or is not a directory. Exiting."
    exit 1
}

cd "${SRC}/${SRC_NAME}"

# Build bliss-analyze
if [ -x scripts/build-bliss-analyze.sh ]
then
  scripts/build-bliss-analyze.sh
else
  PROJ=bliss-analyze
  [ -d ${PROJ} ] || git clone https://github.com/doctorfree/bliss-analyze
  [ -x ${PROJ}/target/release/bliss-analyze ] || {
    have_cargo=`type -p cargo`
    [ "${have_cargo}" ] || {
      echo "The cargo tool cannot be located."
      echo "Cargo is required to build bliss-analyze. Exiting."
      exit 1
    }
    cd ${PROJ}
    cargo build -r
    cd ..
  }
fi

# Build blissify
if [ -x scripts/build-blissify.sh ]
then
  scripts/build-blissify.sh
else
  PROJ=blissify
  [ -d ${PROJ} ] || git clone https://github.com/doctorfree/blissify
  [ -x ${PROJ}/target/release/blissify ] || {
    have_cargo=`type -p cargo`
    [ "${have_cargo}" ] || {
      echo "The cargo tool cannot be located."
      echo "Cargo is required to build blissify. Exiting."
      exit 1
    }
    cd ${PROJ}
    cargo build -r
    cd ..
  }
fi

${SUDO} rm -rf dist
mkdir dist

[ -d ${OUT_DIR} ] && rm -rf ${OUT_DIR}
mkdir ${OUT_DIR}
mkdir ${OUT_DIR}/DEBIAN
chmod 755 ${OUT_DIR} ${OUT_DIR}/DEBIAN

echo "Package: ${PKG}
Version: ${PKG_VER}-${PKG_REL}
Section: sound
Priority: optional
Architecture: ${ARCH}
Depends: ffmpeg, libavformat58 (>= 7:4.1), libavcodec58 (>= 7:4.2), libavutil56 (>= 7:4.0), libsqlite3-0 (>= 3.6.0)
Maintainer: ${DEBFULLNAME} <${DEBEMAIL}>
Installed-Size: 9000
Build-Depends: debhelper (>= 11)
Homepage: https://github.com/doctorfree/mpplus-bliss
Description: Blissify
  Make playlists of songs that sound alike from an MPD track library" > ${OUT_DIR}/DEBIAN/control

chmod 644 ${OUT_DIR}/DEBIAN/control

for dir in "${DESTDIR}" "${DESTDIR}/share" "${DESTDIR}/share/man" \
           "${DESTDIR}/share/doc" \
           "${DESTDIR}/share/doc/${PKG}" "${DESTDIR}/share/${PKG}" \
           "${DESTDIR}/share/doc/${PKG}/blissify" \
           "${DESTDIR}/share/doc/${PKG}/bliss-analyze"
do
    [ -d ${OUT_DIR}/${dir} ] || ${SUDO} mkdir ${OUT_DIR}/${dir}
    ${SUDO} chown root:root ${OUT_DIR}/${dir}
done

for dir in bin
do
    [ -d ${OUT_DIR}/${DESTDIR}/${dir} ] && ${SUDO} rm -rf ${OUT_DIR}/${DESTDIR}/${dir}
done

${SUDO} mkdir -p ${OUT_DIR}/${DESTDIR}/bin
[ -f blissify/target/release/blissify ] && {
  ${SUDO} cp blissify/target/release/blissify ${OUT_DIR}/${DESTDIR}/bin
}
[ -f bliss-analyze/target/release/bliss-analyze ] && {
  ${SUDO} cp bliss-analyze/target/release/bliss-analyze ${OUT_DIR}/${DESTDIR}/bin
}

${SUDO} cp copyright ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp LICENSE ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp NOTICE ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp AUTHORS ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp CHANGELOG.md ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp README.md ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} pandoc -f gfm README.md | ${SUDO} tee ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/README.html > /dev/null
${SUDO} gzip -9 ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/CHANGELOG.md

${SUDO} cp blissify/CHANGELOG.md ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/blissify
${SUDO} cp blissify/README.md ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/blissify

${SUDO} cp bliss-analyze/ChangeLog ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/bliss-analyze
${SUDO} cp bliss-analyze/LICENSE ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/bliss-analyze
${SUDO} cp bliss-analyze/README.md ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/bliss-analyze

${SUDO} cp -a man/man1 ${OUT_DIR}/${DESTDIR}/share/man/man1

${SUDO} chmod 644 ${OUT_DIR}/${DESTDIR}/share/man/*/*
${SUDO} chmod 755 ${OUT_DIR}/${DESTDIR}/bin/* \
                  ${OUT_DIR}/${DESTDIR}/bin \
                  ${OUT_DIR}/${DESTDIR}/share/man \
                  ${OUT_DIR}/${DESTDIR}/share/man/*
${SUDO} chown -R root:root ${OUT_DIR}/${DESTDIR}

cd dist
echo "Building ${PKG_NAME}_${PKG_VER} Debian package"
${SUDO} dpkg --build ${PKG_NAME}_${PKG_VER} ${PKG_NAME}_${PKG_VER}-${PKG_REL}.${ARCH}.deb
cd ${PKG_NAME}_${PKG_VER}
echo "Creating compressed tar archive of ${PKG_NAME} ${PKG_VER} distribution"
tar cf - usr | gzip -9 > ../${PKG_NAME}_${PKG_VER}-${PKG_REL}.tgz

have_zip=`type -p zip`
[ "${have_zip}" ] || {
  ${SUDO} apt-get update
  ${SUDO} apt-get install zip -y
}
echo "Creating zip archive of ${PKG_NAME} ${PKG_VER} distribution"
zip -q -r ../${PKG_NAME}_${PKG_VER}-${PKG_REL}.zip usr

cd ..
[ "${GCI}" ] || {
    [ -d ../releases ] || mkdir ../releases
    [ -d ../releases/${PKG_VER} ] || mkdir ../releases/${PKG_VER}
    ${SUDO} cp *.deb *.tgz *.zip ../releases/${PKG_VER}
}
