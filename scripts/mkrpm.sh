#!/bin/bash
PKG="mpplus-bliss"
SRC_NAME="mpplus-bliss"
PKG_NAME="mpplus-bliss"
DESTDIR="usr"
SRC=${HOME}/src
SUDO=sudo
GCI=

[ -f "${SRC}/${SRC_NAME}/VERSION" ] || {
  [ -f "/builds/doctorfree/${SRC_NAME}/VERSION" ] || {
    echo "$SRC/$SRC_NAME/VERSION does not exist. Exiting."
    exit 1
  }
  SRC="/builds/doctorfree"
  SUDO=
  GCI=1
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
${SUDO} cp blissify/target/release/blissify ${OUT_DIR}/${DESTDIR}/bin
${SUDO} cp bliss-analyze/target/release/bliss-analyze ${OUT_DIR}/${DESTDIR}/bin

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

echo "Building ${PKG_NAME}_${PKG_VER} rpm package"

[ -d pkg/rpm ] && cp -a pkg/rpm ${OUT_DIR}/rpm
[ -d ${OUT_DIR}/rpm ] || mkdir ${OUT_DIR}/rpm

have_rpm=`type -p rpmbuild`
[ "${have_rpm}" ] || {
  have_yum=`type -p yum`
  if [ "${have_yum}" ]
  then
    ${SUDO} yum -y install rpm-build
  else
    ${SUDO} apt-get update
    export DEBIAN_FRONTEND=noninteractive
    ${SUDO} ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
    ${SUDO} apt-get install rpm -y
    ${SUDO} dpkg-reconfigure --frontend noninteractive tzdata
  fi
}

rpmbuild -ba --build-in-place \
   --define "_topdir ${OUT_DIR}" \
   --define "_sourcedir ${OUT_DIR}" \
   --define "_version ${PKG_VER}" \
   --define "_release ${PKG_REL}" \
   --buildroot ${SRC}/${SRC_NAME}/${OUT_DIR}/BUILDROOT \
   ${OUT_DIR}/rpm/${PKG_NAME}.spec

# Rename RPMs if necessary
for rpmfile in ${OUT_DIR}/RPMS/*/*.rpm
do
  [ "${rpmfile}" == "${OUT_DIR}/RPMS/*/*.rpm" ] && continue
  rpmbas=`basename ${rpmfile}`
  rpmdir=`dirname ${rpmfile}`
  newnam=`echo ${rpmbas} | sed -e "s/${PKG_NAME}-${PKG_VER}-${PKG_REL}/${PKG_NAME}_${PKG_VER}-${PKG_REL}/"`
  [ "${rpmbas}" == "${newnam}" ] && continue
  mv ${rpmdir}/${rpmbas} ${rpmdir}/${newnam}
done

${SUDO} cp ${OUT_DIR}/RPMS/*/*.rpm dist

[ "${GCI}" ] || {
    [ -d releases ] || mkdir releases
    [ -d releases/${PKG_VER} ] || mkdir releases/${PKG_VER}
    ${SUDO} cp ${OUT_DIR}/RPMS/*/*.rpm releases/${PKG_VER}
}
