# SPDX-License-Identifier: MIT

# Host GCC 15+ defaults to gnu23; m4 1.4.19 gnulib fails (Buildroot 2024.11).
# https://lists.buildroot.org/pipermail/buildroot/2025-May/778390.html
HOST_M4_CONF_ENV = CFLAGS="$(HOST_CFLAGS) -std=gnu17"

# BR2_EXTERNAL packages (do not duplicate Buildroot builtins like m4)
EXTERNAL_PKG_MKS := $(filter-out \
	$(BR2_EXTERNAL_BIGFRED_HUB_PATH)/package/m4/m4.mk, \
	$(sort $(wildcard $(BR2_EXTERNAL_BIGFRED_HUB_PATH)/package/*/*.mk)))
include $(EXTERNAL_PKG_MKS)
