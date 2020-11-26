################################################################################
#
# python-qui-server
#
################################################################################

PYTHON_QUI_SERVER_VERSION = 1.13.5
PYTHON_QUI_SERVER_SOURCE = qui-server-$(PYTHON_QUI_SERVER_VERSION).tar.gz
PYTHON_QUI_SERVER_SITE = https://files.pythonhosted.org/packages/ea/9d/53ae104bafa2e3f2f3cf3486d1f0658649d02f9975d34efd693e5b802031
PYTHON_QUI_SERVER_SETUP_TYPE = setuptools
PYTHON_QUI_SERVER_LICENSE = Apache-2.0
PYTHON_QUI_SERVER_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
