################################################################################
#
# qtoggleserver-generic-http
#
################################################################################

QTOGGLESERVER_GENERIC_HTTP_VERSION = 1.1.1
QTOGGLESERVER_GENERIC_HTTP_SOURCE = qtoggleserver-generic-http-$(QTOGGLESERVER_GENERIC_HTTP_VERSION).tar.gz
QTOGGLESERVER_GENERIC_HTTP_SITE = https://pypi.io/packages/source/q/qtoggleserver-generic-http
QTOGGLESERVER_GENERIC_HTTP_SETUP_TYPE = setuptools
QTOGGLESERVER_GENERIC_HTTP_DEPENDENCIES = host-python-setupnovernormalize

$(eval $(python-package))
