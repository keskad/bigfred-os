#!/usr/bin/env bash
# Save/restore Buildroot internal toolchain (host-gcc, musl deps) for CI cache.
# Usage: ci-toolchain-cache.sh {save|restore}

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUTPUT_HOST="${ROOT}/os/output/host"
OUTPUT_BUILD="${ROOT}/os/output/build"
CACHE_DIR="${ROOT}/os/.cache/host-toolchain"
CACHE_HOST="${CACHE_DIR}/host"
CACHE_BUILD="${CACHE_DIR}/build"

# Package build dirs required so Buildroot skips host-gcc-initial/final rebuild.
TOOLCHAIN_BUILD_GLOBS=(
	host-binutils-*
	host-gcc-initial-*
	host-gcc-final-*
	host-gmp-*
	host-mpfr-*
	host-mpc-*
	host-isl-*
	linux-headers-*
	musl-*
	musl-compat-headers-*
)

_copy_build_dirs() {
	local dest="$1"
	mkdir -p "$dest"
	shopt -s nullglob
	for pattern in "${TOOLCHAIN_BUILD_GLOBS[@]}"; do
		for dir in "${OUTPUT_BUILD}"/${pattern}; do
			rsync -a --delete "${dir}/" "${dest}/$(basename "${dir}")/"
		done
	done
	shopt -u nullglob
}

cmd="${1:-}"
case "$cmd" in
restore)
	if [[ ! -d "${CACHE_HOST}" ]]; then
		echo "No host toolchain cache to restore."
		exit 0
	fi
	if [[ ! -x "${CACHE_HOST}/bin/aarch64-buildroot-linux-musl-gcc" ]]; then
		echo "Cache missing cross-compiler; skipping restore."
		exit 0
	fi
	mkdir -p "${OUTPUT_HOST}" "${OUTPUT_BUILD}"
	echo "Restoring host toolchain from ${CACHE_DIR}..."
	rsync -a "${CACHE_HOST}/" "${OUTPUT_HOST}/"
	if [[ -d "${CACHE_BUILD}" ]]; then
		for dir in "${CACHE_BUILD}"/*; do
			[[ -d "$dir" ]] || continue
			rsync -a "${dir}/" "${OUTPUT_BUILD}/$(basename "${dir}")/"
		done
	fi
	;;
save)
	if [[ ! -x "${OUTPUT_HOST}/bin/aarch64-buildroot-linux-musl-gcc" ]]; then
		echo "Cross-compiler not built; not updating toolchain cache."
		exit 0
	fi
	echo "Saving host toolchain to ${CACHE_DIR}..."
	rm -rf "${CACHE_DIR}"
	mkdir -p "${CACHE_HOST}"
	rsync -a "${OUTPUT_HOST}/" "${CACHE_HOST}/"
	_copy_build_dirs "${CACHE_BUILD}"
	;;
*)
	echo "Usage: $0 {save|restore}" >&2
	exit 1
	;;
esac
