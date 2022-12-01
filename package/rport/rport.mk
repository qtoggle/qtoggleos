################################################################################
#
# rport
#
################################################################################

RPORT_VERSION = 0.9.0

RPORT_ARCH = $(call qstrip,$(BR2_ARCH))
ifeq ($(RPORT_ARCH), arm)
    RPORT_ARCH = armv7
else
    ifeq ($(RPORT_ARCH), aarch64)
        RPORT_ARCH = arm64
    endif
endif

RPORT_SITE = https://github.com/cloudradar-monitoring/rport/releases/download/$(RPORT_VERSION)
RPORT_SOURCE = rport_$(RPORT_VERSION)_Linux_$(RPORT_ARCH).tar.gz
RPORT_LICENSE = MIT

define RPORT_EXTRACT_CMDS 
    tar xf "$(RPORT_DL_DIR)/$(RPORT_SOURCE)" -C "$(@D)"
endef

define RPORT_BUILD_CMDS
    $(TARGET_STRIP) "$(@D)/rport"
endef

define RPORT_INSTALL_TARGET_CMDS
    cp "$(@D)/rport" $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
