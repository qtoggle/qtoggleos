################################################################################
#
# python-paradox-alarm-interface
#
################################################################################

PYTHON_PARADOX_ALARM_INTERFACE_VERSION = 3.1.0
PYTHON_PARADOX_ALARM_INTERFACE_SOURCE = paradox-alarm-interface-$(PYTHON_PARADOX_ALARM_INTERFACE_VERSION).tar.gz
PYTHON_PARADOX_ALARM_INTERFACE_SITE = https://pypi.io/packages/source/p/paradox-alarm-interface
PYTHON_PARADOX_ALARM_INTERFACE_SETUP_TYPE = setuptools
PYTHON_PARADOX_ALARM_INTERFACE_DEPENDENCIES = python-argparse python-construct python-slugify

$(eval $(python-package))
