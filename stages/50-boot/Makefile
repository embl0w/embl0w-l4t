TOPDIR		= $(CURDIR)
BUILDDIR	= $(TOPDIR)/build
PREBUILTDIR	= $(BUILDDIR)/prebuilt
ROOTFSDIR	= $(BUILDDIR)/rootfs
ROOTFSFILE	= $(ROOTFSDIR).squashfs
BOOTRAMFSDIR	= $(BUILDDIR)/bootramfs
BOOTRAMFSFILE	= $(BOOTRAMFSDIR).gz
BOOTFSDIR	= $(BUILDDIR)/bootfs
BOOTFSTGZ	= $(BOOTFSDIR).tar.gz

SUDO		= sudo

.PHONY: all clean build upload

all:

clean:
	$(SUDO) rm -rf $(BUILDDIR)

build: $(BOOTFSTGZ)

upload:
	upload-artifacts.sh boot $(BOOTFSTGZ)

$(PREBUILTDIR):
	download-artifacts.sh app $(PREBUILTDIR)

$(ROOTFSDIR): $(PREBUILTDIR)
	mkdir -p $@
	$(SUDO) tar -C $@ -xzf $(PREBUILTDIR)/app/rootfs.tar.gz
	$(SUDO) rm -f $@/usr/bin/qemu-arm-static $@/usr/bin/qemu-aarch64-static
	$(SUDO) rm -f $@/etc/apt/apt.conf.d/aptlocal.conf
	$(SUDO) rm -rf $@/var/lib/apt/lists/*

$(ROOTFSFILE): $(ROOTFSDIR)
	$(SUDO) time -v mksquashfs $(ROOTFSDIR) $@ -no-fragments -e /boot

$(BOOTRAMFSFILE): $(ROOTFSDIR)
	mkdir -p $(BOOTRAMFSDIR)/bin
	cp target/bin/busybox /usr/bin/qemu-arm-static $(BOOTRAMFSDIR)/bin
	$(SUDO) chroot $(BOOTRAMFSDIR) qemu-arm-static /bin/busybox --install -s /bin
	rm -f $(BOOTRAMFSDIR)/bin/qemu-arm-static
	tar -C bootramfs -cf - . | $(SUDO) tar -C $(BOOTRAMFSDIR) -xf - 
	(cd $(BOOTRAMFSDIR) && find . | cpio -o --owner 0.0 -H newc) | gzip -c9 > $@

$(BOOTFSTGZ): $(BOOTRAMFSFILE) $(ROOTFSFILE)
	mkdir -p $(BOOTFSDIR)
	tar -C bootfs -cf - . | tar -C $(BOOTFSDIR) -xf -
	-tar -C $(ROOTFSDIR)/boot -cf - . | tar -C $(BOOTFSDIR)/boot -xf -
	cp $(BOOTRAMFSFILE) $(BOOTFSDIR)/boot/initrd
	cp $(ROOTFSFILE) $(BOOTFSDIR)/boot/rootfs.squashfs
	cd $(BOOTFSDIR) && find . -type f | xargs sha256sum | gzip -c9 >$(BUILDDIR)/SHA256SUM.txt.gz
	mv $(BUILDDIR)/SHA256SUM.txt.gz $(BOOTFSDIR)
	tar --owner=0 --group=0 -C $(BOOTFSDIR) -czvf - . >$@
