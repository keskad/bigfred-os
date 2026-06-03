################################################################################
#
# m4 (host) — override Buildroot 2024.11
#
# GCC 15+ defaults to -std=gnu23; gnulib in m4 1.4.19 fails to compile.
# https://lists.buildroot.org/pipermail/buildroot/2025-May/778390.html
#
################################################################################

M4_VERSION = 1.4.19
M4_SOURCE = m4-$(M4_VERSION).tar.xz
M4_SITE = $(BR2_GNU_MIRROR)/m4
M4_LICENSE = GPL-3.0+
M4_LICENSE_FILES = COPYING

HOST_M4_CONF_ENV = CFLAGS="$(HOST_CFLAGS) -std=gnu17"

$(eval $(host-autotools-package))
