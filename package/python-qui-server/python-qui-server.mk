################################################################################
#
# python-qui-server
#
################################################################################

PYTHON_QUI_SERVER_VERSION = 1.13.3
PYTHON_QUI_SERVER_SOURCE = qui-server-$(PYTHON_QUI_SERVER_VERSION).tar.gz
PYTHON_QUI_SERVER_SITE = https://files.pythonhosted.org/packages/47/41/ffffe9caf981db79ea29a8168c8390a64f8916b8eb62123c0acdd8b15b5e
PYTHON_QUI_SERVER_SETUP_TYPE = setuptools
PYTHON_QUI_SERVER_LICENSE = Apache-2.0
PYTHON_QUI_SERVER_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
