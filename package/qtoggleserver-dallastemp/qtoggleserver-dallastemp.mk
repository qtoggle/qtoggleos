################################################################################
#
# qtoggleserver-dallastemp
#
################################################################################

QTOGGLESERVER_DALLASTEMP_VERSION = 1.2.2
QTOGGLESERVER_DALLASTEMP_SOURCE = qtoggleserver-dallastemp-$(QTOGGLESERVER_DALLASTEMP_VERSION).tar.gz
QTOGGLESERVER_DALLASTEMP_SITE = https://pypi.io/packages/source/q/qtoggleserver-dallastemp
QTOGGLESERVER_DALLASTEMP_SETUP_TYPE = setuptools
QTOGGLESERVER_DALLASTEMP_DEPENDENCIES = host-python-setupnovernormalize

$(eval $(python-package))
