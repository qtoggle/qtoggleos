################################################################################
#
# python-construct
#
################################################################################

PYTHON_CONSTRUCT_VERSION = 2.9.52
PYTHON_CONSTRUCT_SOURCE = construct-$(PYTHON_CONSTRUCT_VERSION).tar.gz
PYTHON_CONSTRUCT_SITE = https://pypi.io/packages/source/c/construct
PYTHON_CONSTRUCT_SETUP_TYPE = setuptools

$(eval $(python-package))
