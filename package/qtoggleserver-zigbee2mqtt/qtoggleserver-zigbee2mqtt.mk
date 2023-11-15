################################################################################
#
# qtoggleserver-zigbee2mqtt
#
################################################################################

QTOGGLESERVER_ZIGBEE2MQTT_VERSION = 1.0.0
QTOGGLESERVER_ZIGBEE2MQTT_SOURCE = qtoggleserver-zigbee2mqtt-$(QTOGGLESERVER_ZIGBEE2MQTT_VERSION).tar.gz
QTOGGLESERVER_ZIGBEE2MQTT_SITE = https://pypi.io/packages/source/q/qtoggleserver-zigbee2mqtt
QTOGGLESERVER_ZIGBEE2MQTT_SETUP_TYPE = setuptools
QTOGGLESERVER_ZIGBEE2MQTT_DEPENDENCIES = host-python-setupnovernormalize python-aiomqtt

$(eval $(python-package))
