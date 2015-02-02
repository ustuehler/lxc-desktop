#!/usr/bin/make -f

INSTALL_DIR = install -m 755 -d
INSTALL_FILE = install -m 644
INSTALL_SCRIPT = install -m 755

all:

install:
	${INSTALL_DIR} ${DESTDIR}/usr/share/lxc/config
	${INSTALL_DIR} ${DESTDIR}/usr/share/lxc/hooks
	${INSTALL_DIR} ${DESTDIR}/usr/share/lxc/templates
	${INSTALL_FILE} usr/share/lxc/config/desktop.conf ${DESTDIR}/usr/share/lxc/config
	${INSTALL_SCRIPT} usr/share/lxc/hooks/desktop-autodev ${DESTDIR}/usr/share/lxc/hooks
	${INSTALL_SCRIPT} usr/share/lxc/templates/lxc-ubuntu-desktop ${DESTDIR}/usr/share/lxc/templates
