################################################################################
#
# qtoggleserver-pylontech
#
################################################################################

QTOGGLESERVER_PYLONTECH_VERSION = 1.0.3
QTOGGLESERVER_PYLONTECH_SOURCE = qtoggleserver-pylontech-$(QTOGGLESERVER_PYLONTECH_VERSION).tar.gz
QTOGGLESERVER_PYLONTECH_SITE = https://pypi.io/packages/source/q/qtoggleserver-pylontech
QTOGGLESERVER_PYLONTECH_SETUP_TYPE = setuptools
QTOGGLESERVER_PYLONTECH_DEPENDENCIES = host-python-setupnovernormalize python-pylontech

$(eval $(python-package))
