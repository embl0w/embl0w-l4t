TOPDIR		= $(CURDIR)
BUILDDIR	= $(TOPDIR)/build
PREBUILTDIR	= $(BUILDDIR)/prebuilt
ROOTFSDIR	= $(BUILDDIR)/rootfs
ROOTFSTGZ	= $(BUILDDIR)/rootfs.tar.gz

SUDO		= sudo

.PHONY: all clean build upload

all:

clean:
	$(SUDO) rm -rf $(BUILDDIR)

build: $(ROOTFSTGZ)

upload:
	upload-artifacts.sh root $(ROOTFSTGZ)

$(PREBUILTDIR):
	download-artifacts.sh debootstrap $(PREBUILTDIR)

$(ROOTFSTGZ): $(PREBUILTDIR)
	mkdir -p $(ROOTFSDIR)
	$(SUDO) tar -C $(ROOTFSDIR) -xzf $(PREBUILTDIR)/debootstrap/rootfs.tar.gz
	tar --owner=0 --group=0 -C rootfs -cf - . | $(SUDO) tar -C $(ROOTFSDIR) -xf -
	$(SUDO) env DEBIAN_FRONTEND=noninteractive HOSTNAME=jetson chroot $(ROOTFSDIR) /setup.sh
	$(SUDO) tar --numeric-owner -C $(ROOTFSDIR) -czf - . >$@
