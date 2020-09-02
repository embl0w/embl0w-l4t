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
	upload-artifacts.sh app $(ROOTFSTGZ)

$(PREBUILTDIR):
	download-artifacts.sh root $(PREBUILTDIR)

$(ROOTFSTGZ): $(PREBUILTDIR)
	mkdir -p $(ROOTFSDIR)
	$(SUDO) tar -C $(ROOTFSDIR) -xzf $(PREBUILTDIR)/root/rootfs.tar.gz
	tar --owner=0 --group=0 -C rootfs -cf - . | $(SUDO) tar -C $(ROOTFSDIR) -xf -
	$(SUDO) env DEBIAN_FRONTEND=noninteractive chroot $(ROOTFSDIR) /setup.sh
	$(SUDO) tar --numeric-owner -C $(ROOTFSDIR) -czf - . >$@
