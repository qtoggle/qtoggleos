################################################################################
#
# python-text-unidecode
#
################################################################################

PYTHON_TEXT_UNIDECODE_VERSION = 1.3
PYTHON_TEXT_UNIDECODE_SOURCE = text-unidecode-$(PYTHON_TEXT_UNIDECODE_VERSION).tar.gz
PYTHON_TEXT_UNIDECODE_SITE = https://pypi.io/packages/source/t/text-unidecode
PYTHON_TEXT_UNIDECODE_SETUP_TYPE = setuptools

$(eval $(python-package))
