################################################################################
#
# python-qui-server
#
################################################################################

PYTHON_QUI_SERVER_VERSION = 1.16.1
PYTHON_QUI_SERVER_SOURCE = qui-server-$(PYTHON_QUI_SERVER_VERSION).tar.gz
PYTHON_QUI_SERVER_SITE = https://files.pythonhosted.org/packages/fd/ea/7e860cae6c62f18cfa7f47d6754ed6cc5755ee1b9b2d0a9246460055333d
PYTHON_QUI_SERVER_SETUP_TYPE = setuptools
PYTHON_QUI_SERVER_LICENSE = Apache-2.0
PYTHON_QUI_SERVER_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
