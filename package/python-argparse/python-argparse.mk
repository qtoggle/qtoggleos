################################################################################
#
# python-argparse
#
################################################################################

PYTHON_ARGPARSE_VERSION = 1.4.0
PYTHON_ARGPARSE_SOURCE = argparse-$(PYTHON_ARGPARSE_VERSION).tar.gz
PYTHON_ARGPARSE_SITE = https://pypi.io/packages/source/a/argparse
PYTHON_ARGPARSE_SETUP_TYPE = setuptools

$(eval $(python-package))
