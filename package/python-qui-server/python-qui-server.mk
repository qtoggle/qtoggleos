################################################################################
#
# python-qui-server
#
################################################################################

PYTHON_QUI_SERVER_VERSION = 1.16.2
PYTHON_QUI_SERVER_SOURCE = qui-server-$(PYTHON_QUI_SERVER_VERSION).tar.gz
PYTHON_QUI_SERVER_SITE = https://pypi.io/packages/source/q/qui-server
PYTHON_QUI_SERVER_SETUP_TYPE = setuptools
PYTHON_QUI_SERVER_LICENSE = Apache-2.0
PYTHON_QUI_SERVER_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
