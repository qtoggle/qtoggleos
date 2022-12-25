################################################################################
#
# python-pylontech
#
################################################################################

PYTHON_PYLONTECH_VERSION = 0.2.1
PYTHON_PYLONTECH_SOURCE = python-pylontech-$(PYTHON_PYLONTECH_VERSION).tar.gz
PYTHON_PYLONTECH_SITE = https://pypi.io/packages/source/p/python-pylontech
PYTHON_PYLONTECH_SETUP_TYPE = setuptools

$(eval $(python-package))
