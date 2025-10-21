################################################################################
#
# ch347-vcp
#
################################################################################

CH347_VCP_VERSION = aadddf7
CH347_VCP_SITE = $(call github,aystarik,ch347_vcp,$(CH347_VCP_VERSION))

#define CH347_VCP_BUILD_CMDS
#	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) KERNEL_SRC=$(LINUX_DIR)
#endef

#define CH347_VCP_INSTALL_TARGET_CMDS
#	$(INSTALL) -D -m 0755 $(@D)/nbcat $(TARGET_DIR)/usr/bin/nbcat
#endef

$(eval $(kernel-module))
$(eval $(generic-package))
