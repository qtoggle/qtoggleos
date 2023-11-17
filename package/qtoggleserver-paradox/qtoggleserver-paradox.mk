################################################################################
#
# qtoggleserver-paradox
#
################################################################################

QTOGGLESERVER_PARADOX_VERSION = 1.5.2
QTOGGLESERVER_PARADOX_SOURCE = qtoggleserver-paradox-$(QTOGGLESERVER_PARADOX_VERSION).tar.gz
QTOGGLESERVER_PARADOX_SITE = https://pypi.io/packages/source/q/qtoggleserver-paradox
QTOGGLESERVER_PARADOX_SETUP_TYPE = setuptools
QTOGGLESERVER_PARADOX_DEPENDENCIES = host-python-setupnovernormalize python-paradox-alarm-interface

$(eval $(python-package))
