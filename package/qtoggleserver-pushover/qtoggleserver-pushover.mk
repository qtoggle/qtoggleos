################################################################################
#
# qtoggleserver-pushover
#
################################################################################

QTOGGLESERVER_PUSHOVER_VERSION = 1.3.0
QTOGGLESERVER_PUSHOVER_SOURCE = qtoggleserver-pushover-$(QTOGGLESERVER_PUSHOVER_VERSION).tar.gz
QTOGGLESERVER_PUSHOVER_SITE = https://pypi.io/packages/source/q/qtoggleserver-pushover
QTOGGLESERVER_PUSHOVER_SETUP_TYPE = setuptools
QTOGGLESERVER_PUSHOVER_DEPENDENCIES = host-python-setupnovernormalize

$(eval $(python-package))
