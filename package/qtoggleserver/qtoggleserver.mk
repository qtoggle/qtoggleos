################################################################################
#
# qtoggleserver
#
################################################################################

QTOGGLESERVER_VERSION = 0.21.0-beta.2
QTOGGLESERVER_SOURCE = qtoggleserver-$(QTOGGLESERVER_VERSION).tar.gz
QTOGGLESERVER_SITE = https://github.com/qtoggle/qtoggleserver/releases/download/version-$(QTOGGLESERVER_VERSION)
QTOGGLESERVER_SETUP_TYPE = setuptools
QTOGGLESERVER_DEPENDENCIES = host-python-fastentrypoints host-python-setupnovernormalize

define QTOGGLESERVER_PATCH_VERSION
    if [ -n "$(THINGOS_VERSION)" ]; then \
        sed -ir "s/VERSION = .*/VERSION = '$(THINGOS_VERSION)'/" $(@D)/qtoggleserver/version.py; \
    fi
endef

QTOGGLESERVER_PRE_BUILD_HOOKS += QTOGGLESERVER_PATCH_VERSION

$(eval $(python-package))
