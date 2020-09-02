TOPDIR		= $(CURDIR)
BUILDDIR	= $(TOPDIR)/build
PREBUILTDIR	= $(BUILDDIR)/prebuilt
BOOTFSDIR	= $(BUILDDIR)/bootfs
L4TDIR		= $(BUILDDIR)/Linux_for_Tegra
BOOTIMG		= $(BUILDDIR)/boot.img
BOOTIMGGZ	= $(BOOTIMG).gz

SUDO		= sudo

.PHONY: all clean build upload

all:

clean:
	$(SUDO) rm -rf $(BUILDDIR)

build: $(BOOTIMGGZ)

upload:
	upload-artifacts.sh image $(BOOTIMGGZ)

$(PREBUILTDIR):
	download-artifacts.sh boot $(PREBUILTDIR)
	download-artifacts.sh firmware $(PREBUILTDIR)

$(BOOTFSDIR): $(PREBUILTDIR)
	mkdir -p $@
	tar -C $@ -xzf $(PREBUILTDIR)/boot/bootfs.tar.gz

$(L4TDIR): $(PREBUILTDIR)
	tar -C $(BUILDDIR) -xjf $(PREBUILTDIR)/firmware/l4t.tar.bz2
	# XXX: make rootfs_size hardcoded to 512MB
	sed -i -e 's/rootfs_size=.*/rootfs_size=512/g' $(L4TDIR)/tools/jetson-disk-image-creator.sh

$(BOOTIMG): $(BOOTFSDIR) $(L4TDIR)
	# XXX: refuse stock initrd
	cp $(BOOTFSDIR)/boot/initrd $(L4TDIR)/bootloader/l4t_initrd.img
	$(SUDO) env ROOTFS_DIR=$(BOOTFSDIR) $(L4TDIR)/tools/jetson-disk-image-creator.sh -o $@ -b jetson-nano -r 300

$(BOOTIMGGZ): $(BOOTIMG)
	gzip -c9 $(BOOTIMG) >$@
