# SPDX-License-Identifier: MIT
# Optional: place alloy-linux-arm64 next to this file and enable BR2_PACKAGE_ALLOY.

ALLOY_VERSION = 1.0.0
ALLOY_LICENSE = Apache-2.0
ALLOY_SITE = $(ALLOY_PKGDIR)
ALLOY_SITE_METHOD = local

define ALLOY_INSTALL_TARGET_CMDS
	if [ -f $(ALLOY_SITE)/alloy-linux-arm64 ]; then \
		$(INSTALL) -D -m 0755 $(ALLOY_SITE)/alloy-linux-arm64 \
			$(TARGET_DIR)/usr/bin/alloy; \
	else \
		echo "BR2_PACKAGE_ALLOY=y but alloy-linux-arm64 missing in package/alloy/"; \
		exit 1; \
	fi
endef

$(eval $(generic-package))
