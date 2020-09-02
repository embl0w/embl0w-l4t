TOPDIR		= $(CURDIR)
BUILDDIR	= $(TOPDIR)/build
SCRIPTSDIR	= $(TOPDIR)/scripts
ARTIFACTSDIR	= $(TOPDIR)/artifacts

SUDO		= sudo

export SHAREDARTIFACTSDIR = $(ARTIFACTSDIR)
export APTPROXY ?=
export PATH := $(SCRIPTSDIR):$(PATH)

STAGES = \
	10-firmware \
	20-debootstrap \
	30-root \
	40-app \
	50-boot \
	60-image

.PHONY: all clean setup build

all:

clean:
	$(SUDO) rm -rf $(BUILDDIR)
	set -e && for i in $(STAGES); do $(SUDO) make -C stages/$$i clean; done

setup:
	$(SUDO) apt update
	$(SUDO) apt install -y --no-install-recommends sudo build-essential ca-certificates binfmt-support qemu-user-static debootstrap squashfs-tools cpio curl git gnupg time gdisk
	mkdir -p $(BUILDDIR)
	curl -o $(BUILDDIR)/rclone.deb $$(rclone-current-url.sh)
	$(SUDO) apt install -y $(BUILDDIR)/rclone.deb

build:
	set -e && for i in $(STAGES); do make -C stages/$$i build upload; done
