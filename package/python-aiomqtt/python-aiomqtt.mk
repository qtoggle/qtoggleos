################################################################################
#
# python-aiomqtt
#
################################################################################

PYTHON_AIOMQTT_VERSION = 1.2.1
PYTHON_AIOMQTT_SOURCE = aiomqtt-$(PYTHON_AIOMQTT_VERSION).tar.gz
PYTHON_AIOMQTT_SITE = https://files.pythonhosted.org/packages/b3/14/ad6078503b375fbc5ab7ad9ba1b8783b5304f9333ba5aa2afe7627ef2411
PYTHON_AIOMQTT_SETUP_TYPE = pep517
PYTHON_AIOMQTT_LICENSE = AS-IS
PYTHON_AIOMQTT_LICENSE_FILES = LICENSE
PYTHON_AIOMQTT_DEPENDENCIES = python-paho-mqtt

# TODO: remove this once we upgrade qToggleOS to a BuildToot version with PEP517 support
define PYTHON_AIOMQTT_INSTALL_TARGET_CMDS
        cp -r $(@D)/aiomqtt \
                $(TARGET_DIR)/usr/lib/python3.9/site-packages
endef

# TODO: replace with `python-package`
$(eval $(generic-package))
