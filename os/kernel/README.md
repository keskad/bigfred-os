# Kernel configuration

Kernel options for the hub are applied via Buildroot fragment files:

- `../configs/linux-4k-page-size.fragment` — 4K pages (Pi 5 / aarch64)
- `../configs/linux-hub.fragment` — PREEMPT_RT, watchdog, USB-ACM, ext4

The kernel source is fetched by Buildroot from `raspberrypi/linux` (see defconfig).
To use a different tag or an RT branch, change `BR2_LINUX_KERNEL_CUSTOM_TARBALL_*`
in `configs/bigfred_hub_rpi5_defconfig`.
