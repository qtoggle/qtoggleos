################################################################################
#
# qtoggleserver-mppsolar
#
################################################################################

QTOGGLESERVER_MPPSOLAR_VERSION = 1.5.0
QTOGGLESERVER_MPPSOLAR_SOURCE = qtoggleserver-mppsolar-$(QTOGGLESERVER_MPPSOLAR_VERSION).tar.gz
QTOGGLESERVER_MPPSOLAR_SITE = https://pypi.io/packages/source/q/qtoggleserver-mppsolar
QTOGGLESERVER_MPPSOLAR_SETUP_TYPE = setuptools
QTOGGLESERVER_MPPSOLAR_DEPENDENCIES = host-python-setupnovernormalize

$(eval $(python-package))
