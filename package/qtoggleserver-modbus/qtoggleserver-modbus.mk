################################################################################
#
# qtoggleserver-modbus
#
################################################################################

QTOGGLESERVER_MODBUS_VERSION = 1.1.2
QTOGGLESERVER_MODBUS_SOURCE = qtoggleserver-modbus-$(QTOGGLESERVER_MODBUS_VERSION).tar.gz
QTOGGLESERVER_MODBUS_SITE = https://pypi.io/packages/source/q/qtoggleserver-modbus
QTOGGLESERVER_MODBUS_SETUP_TYPE = setuptools
QTOGGLESERVER_MODBUS_DEPENDENCIES = host-python-setupnovernormalize python-pymodbus

$(eval $(python-package))
