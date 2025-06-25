################################################################################
#
# cloudflared
#
################################################################################

CLOUDFLARED_VERSION = 2022.7.1

CLOUDFLARED_ARCH = $(call qstrip,$(BR2_ARCH))
ifeq ($(CLOUDFLARED_ARCH), arm)
    CLOUDFLARED_ARCH = armhf
else
    ifeq ($(CLOUDFLARED_ARCH), aarch64)
        CLOUDFLARED_ARCH = arm64
    endif
endif

CLOUDFLARED_SITE = https://github.com/cloudflare/cloudflared/releases/download/$(CLOUDFLARED_VERSION)
CLOUDFLARED_SOURCE = cloudflared-linux-$(CLOUDFLARED_ARCH)
CLOUDFLARED_LICENSE = Apache-2.0

define CLOUDFLARED_EXTRACT_CMDS 
    cp "$(CLOUDFLARED_DL_DIR)/$(CLOUDFLARED_SOURCE)" "$(@D)"
endef

define CLOUDFLARED_BUILD_CMDS
    $(TARGET_STRIP) $(@D)/$(CLOUDFLARED_SOURCE) -o $(@D)/cloudflared
    xz "$(@D)/cloudflared" -z -c > "$(@D)/cloudflared.xz"
endef

define CLOUDFLARED_INSTALL_TARGET_CMDS
    cp "$(@D)/cloudflared.xz" $(TARGET_DIR)/usr/libexec
endef

$(eval $(generic-package))
