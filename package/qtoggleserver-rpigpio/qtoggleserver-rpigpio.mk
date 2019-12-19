################################################################################
#
# qtoggleserver-rpigpio
#
################################################################################

QTOGGLESERVER_RPIGPIO_VERSION = 1.0.0
QTOGGLESERVER_RPIGPIO_SOURCE = qtoggleserver-rpigpio-$(QTOGGLESERVER_RPIGPIO_VERSION).tar.gz
QTOGGLESERVER_RPIGPIO_SITE = https://pypi.io/packages/source/q/qtoggleserver-rpigpio
QTOGGLESERVER_RPIGPIO_SETUP_TYPE = setuptools
QTOGGLESERVER_RPIGPIO_DEPENDENCIES = host-python-setupnovernormalize

$(eval $(python-package))
