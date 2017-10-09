#$Id: 8358f4627abc6a605d650f0e3cc76828b21c88e2 $
# $Date: Thu Sep 3 08:40:55 2015 -0700$
#
Name= diskscan
Version= 1.0
Package= diskscan-1.0-3
Source= ${Package}.tgz
BASE= $(shell pwd)

RPMBUILD= ${HOME}/rpmbuild
RPM_BUILD_ROOT= ${RPMBUILD}/BUILDROOT

DOC_DIR= /usr/share/doc/${Name}-${Version}
SBIN_DIR= /usr/local/sbin

SBIN_FILES= diskscan.sh

DOC_FILES= changelog \
	readme

CRON_DAILY_FILES= diskscan.cron

rpmbuild: specfile source
	rpmbuild -bb --buildroot ${RPM_BUILD_ROOT} ${RPMBUILD}/SPECS/${Package}.spec

specfile: spec
	cat ./spec > ${RPMBUILD}/SPECS/${Package}.spec

source:
	if [ ! -d ${RPMBUILD}/SOURCES/${Name} ]; then \
		mkdir ${RPMBUILD}/SOURCES/${Name}; \
	fi
	rsync -av * ${RPMBUILD}/SOURCES/${Name}
	tar czvf ${RPMBUILD}/SOURCES/${Source} --exclude=.git -C ${RPMBUILD}/SOURCES ${Name}
	rm -fr ${RPMBUILD}/SOURCES/${Name}

install: make_path doc cron 
	@for file in ${SBIN_FILES}; do \
		install -p $$file ${RPM_BUILD_ROOT}/${SBIN_DIR}; \
	done;

make_path:
	@if [ ! -d ${RPM_BUILD_ROOT}/${DOC_DIR} ]; then \
		mkdir -m 0755 -p ${RPM_BUILD_ROOT}/${DOC_DIR}; \
	fi;
	@if [ ! -d ${RPM_BUILD_ROOT}/etc/cron.daily ]; then \
		mkdir -m 0755 -p ${RPM_BUILD_ROOT}/etc/cron.daily; \
	fi;
	@if [ ! -d ${RPM_BUILD_ROOT}/usr/local/sbin ]; then \
		mkdir -m 0755 -p ${RPM_BUILD_ROOT}/usr/local/sbin; \
	fi;

doc:
	@for file in ${DOC_FILES}; do \
		install -p $$file ${RPM_BUILD_ROOT}/${DOC_DIR}; \
	done;

cron: crondaily

crondaily:
	@for file in ${CRON_DAILY_FILES}; do \
		install -p $$file ${RPM_BUILD_ROOT}/etc/cron.daily; \
	done;

clean:
	@rm -f ${RPMBUILD}/SPECS/${Package}.spec
	@rm -fR ${RPMBUILD}/SOURCES/${Source}
	@rm -fR ${RPMBUILD}/BUILD/${Name}
	@rm -fR ${RPMBUILD}/BUILDROOT/*

