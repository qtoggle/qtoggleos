################################################################################
#
# qtoggleserver-cmdline
#
################################################################################

QTOGGLESERVER_CMDLINE_VERSION = 1.0.2
QTOGGLESERVER_CMDLINE_SOURCE = qtoggleserver-cmdline-$(QTOGGLESERVER_CMDLINE_VERSION).tar.gz
QTOGGLESERVER_CMDLINE_SITE = https://pypi.io/packages/source/q/qtoggleserver-cmdline
QTOGGLESERVER_CMDLINE_SETUP_TYPE = setuptools
QTOGGLESERVER_CMDLINE_DEPENDENCIES = host-python-setupnovernormalize

$(eval $(python-package))
