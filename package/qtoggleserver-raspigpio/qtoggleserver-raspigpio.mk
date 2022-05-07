################################################################################
#
# qtoggleserver-raspigpio
#
################################################################################

QTOGGLESERVER_RASPIGPIO_VERSION = 1.1.2
QTOGGLESERVER_RASPIGPIO_SOURCE = qtoggleserver-raspigpio-$(QTOGGLESERVER_RASPIGPIO_VERSION).tar.gz
QTOGGLESERVER_RASPIGPIO_SITE = https://pypi.io/packages/source/q/qtoggleserver-raspigpio
QTOGGLESERVER_RASPIGPIO_SETUP_TYPE = setuptools
QTOGGLESERVER_RASPIGPIO_DEPENDENCIES = host-python-setupnovernormalize

$(eval $(python-package))
