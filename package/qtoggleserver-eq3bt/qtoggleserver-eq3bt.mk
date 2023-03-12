################################################################################
#
# qtoggleserver-eq3bt
#
################################################################################

QTOGGLESERVER_EQ3BT_VERSION = 1.4.1
QTOGGLESERVER_EQ3BT_SOURCE = qtoggleserver-eq3bt-$(QTOGGLESERVER_EQ3BT_VERSION).tar.gz
QTOGGLESERVER_EQ3BT_SITE = https://pypi.io/packages/source/q/qtoggleserver-eq3bt
QTOGGLESERVER_EQ3BT_SETUP_TYPE = setuptools
QTOGGLESERVER_EQ3BT_DEPENDENCIES = host-python-setupnovernormalize

$(eval $(python-package))
