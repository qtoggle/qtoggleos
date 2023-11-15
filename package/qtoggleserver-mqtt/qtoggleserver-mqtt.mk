################################################################################
#
# qtoggleserver-mqtt
#
################################################################################

QTOGGLESERVER_MQTT_VERSION = 1.0.0
QTOGGLESERVER_MQTT_SOURCE = qtoggleserver-mqtt-$(QTOGGLESERVER_MQTT_VERSION).tar.gz
QTOGGLESERVER_MQTT_SITE = https://pypi.io/packages/source/q/qtoggleserver-mqtt
QTOGGLESERVER_MQTT_SETUP_TYPE = setuptools
QTOGGLESERVER_MQTT_DEPENDENCIES = host-python-setupnovernormalize python-aiomqtt

$(eval $(python-package))
