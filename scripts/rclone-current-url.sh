#!/bin/sh

set -e

ARCH=$(dpkg-architecture -qDEB_BUILD_ARCH)

case $ARCH in
i386) ARCH=386 ;;
amd64) ARCH=amd64 ;;
armel|armhf) ARCH=arm ;;
arm64) ARCH=arm64 ;;
*) echo "Unsupported architecture: $ARCH" >&2 && exit 1 ;;
esac

echo "https://downloads.rclone.org/rclone-current-linux-$ARCH.deb"