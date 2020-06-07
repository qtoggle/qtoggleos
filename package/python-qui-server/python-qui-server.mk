################################################################################
#
# python-qui-server
#
################################################################################

PYTHON_QUI_SERVER_VERSION = 1.11.1
PYTHON_QUI_SERVER_SOURCE = qui-server-$(PYTHON_QUI_SERVER_VERSION).tar.gz
PYTHON_QUI_SERVER_SITE = https://files.pythonhosted.org/packages/a4/d3/e2e043cdc17119f24806a3f37f756493fdf195d486b620e813af6954c2d0
PYTHON_QUI_SERVER_SETUP_TYPE = setuptools
PYTHON_QUI_SERVER_LICENSE = Apache-2.0
PYTHON_QUI_SERVER_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
