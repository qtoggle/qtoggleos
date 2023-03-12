################################################################################
#
# qtoggleserver-thingspeak
#
################################################################################

QTOGGLESERVER_THINGSPEAK_VERSION = 1.1.5
QTOGGLESERVER_THINGSPEAK_SOURCE = qtoggleserver-thingspeak-$(QTOGGLESERVER_THINGSPEAK_VERSION).tar.gz
QTOGGLESERVER_THINGSPEAK_SITE = https://pypi.io/packages/source/q/qtoggleserver-thingspeak
QTOGGLESERVER_THINGSPEAK_SETUP_TYPE = setuptools
QTOGGLESERVER_THINGSPEAK_DEPENDENCIES = host-python-setupnovernormalize

$(eval $(python-package))
