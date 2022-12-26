################################################################################
#
# python-slugify
#
################################################################################

PYTHON_SLUGIFY_VERSION = 7.0.0
PYTHON_SLUGIFY_SOURCE = python-slugify-$(PYTHON_SLUGIFY_VERSION).tar.gz
PYTHON_SLUGIFY_SITE = https://pypi.io/packages/source/p/python-slugify
PYTHON_SLUGIFY_SETUP_TYPE = setuptools
PYTHON_SLUGIFY_DEPENDENCIES = python-text-unidecode

$(eval $(python-package))
