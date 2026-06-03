#!/bin/sh
# Flash hub image to NVMe (run on a build host with the target disk visible)
# Usage: sudo ./scripts/flash-nvme.sh /dev/nvme0n1 [path/to/hub-nvme.img]

set -e

DEV="${1:?Usage: $0 /dev/nvme0n1 [image.img]}"
IMG="${2:-$(dirname "$0")/../output/images/hub-nvme.img}"

if [ ! -b "$DEV" ]; then
	echo "error: $DEV is not a block device" >&2
	exit 1
fi
if [ ! -f "$IMG" ]; then
	echo "error: image not found: $IMG (build with: make image)" >&2
	exit 1
fi

echo "WARNING: all data on ${DEV} will be destroyed."
echo "Image: ${IMG}"
printf "Type YES to continue: "
read -r confirm
[ "$confirm" = YES ] || exit 1

for p in "${DEV}"p*; do
	[ -b "$p" ] && umount "$p" 2>/dev/null || true
done

dd if="$IMG" of="$DEV" bs=4M conv=fsync status=progress
sync
partprobe "$DEV" 2>/dev/null || true

echo "Done. Install NVMe in Pi 5 M.2 HAT+ and boot."
