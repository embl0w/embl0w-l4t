SUITE		= bionic
ARCH		= arm64
MIRRORURL	= $(UBUNTUREPOURL)
VARIANT		= minbase
INCLUDE		= dpkg
EXCLUDE		= nano
TOPDIR		= $(CURDIR)
BUILDDIR	= $(TOPDIR)/build
SOURCESLIST	= $(BUILDDIR)/sources.list
APTLOCALCONF	= $(BUILDDIR)/aptlocal.conf
GNUPGDIR	= $(BUILDDIR)/gnupg
PUBKEY		= $(BUILDDIR)/key
ROOTFSDIR	= $(BUILDDIR)/rootfs
ROOTFSTGZ	= $(BUILDDIR)/rootfs.tar.gz

DEBOOTSTRAP	= qemu-debootstrap
SUDO		= sudo

UBUNTUREPOURL		= http://ports.ubuntu.com/ubuntu-ports

APTPROXY		?=

CI_REGISTRY		?=
CI_REGISTRY_USER	?=
CI_REGISTRY_PASSWORD	?=
CI_REGISTRY_IMAGE	?= embl0w-l4t

.PHONY: all clean build upload docker

all:

clean:
	$(SUDO) rm -rf $(BUILDDIR)

build: $(ROOTFSTGZ)

upload:
	upload-artifacts.sh debootstrap $(ROOTFSTGZ)

docker:
	zcat $(ROOTFSTGZ) | docker import - rootfs-base
	docker tag rootfs-base $(CI_REGISTRY_IMAGE)/$(PRODUCT)/base
	docker build -t $(CI_REGISTRY_IMAGE)/$(PRODUCT)/build .
ifneq ($(CI_REGISTRY),)
	docker login -u $(CI_REGISTRY_USER) -p $(CI_REGISTRY_PASSWORD) $(CI_REGISTRY)
	docker push $(CI_REGISTRY_IMAGE)/$(PRODUCT)/base
	docker push $(CI_REGISTRY_IMAGE)/$(PRODUCT)/build
endif

$(BUILDDIR) $(ROOTFSDIR):
	mkdir -p $@

$(SOURCESLIST): $(BUILDDIR)
	echo "deb $(UBUNTUREPOURL) $(SUITE) main universe multiverse" >>$@
	echo "deb $(UBUNTUREPOURL) $(SUITE)-updates main universe multiverse" >>$@
	echo "deb $(UBUNTUREPOURL) $(SUITE)-security main universe multiverse" >>$@

$(APTLOCALCONF): $(BUILDDIR)
	echo 'apt::install-recommends false;' >>$@
ifneq ($(APTPROXY),)
	echo 'acquire::http::proxy "$(APTPROXY)";' >>$@
endif

$(ROOTFSTGZ): $(ROOTFSDIR) $(SOURCESLIST) $(APTLOCALCONF)
	$(SUDO) env http_proxy=$(APTPROXY) $(DEBOOTSTRAP) \
		--no-merged-usr \
		--arch $(ARCH) \
		--variant $(VARIANT) \
		--include $(INCLUDE) \
		--exclude $(EXCLUDE) \
		$(SUITE) $(ROOTFSDIR) $(MIRRORURL)
	$(SUDO) cp $(SOURCESLIST) $(ROOTFSDIR)/etc/apt/sources.list
	$(SUDO) cp $(APTLOCALCONF) $(ROOTFSDIR)/etc/apt/apt.conf.d
	$(SUDO) chroot $(ROOTFSDIR) apt update
	$(SUDO) chroot $(ROOTFSDIR) apt -y dist-upgrade
	$(SUDO) rm -rf $(ROOTFSDIR)/var/lib/apt/* $(ROOTFSDIR)/var/cache/apt/*
	$(SUDO) tar --numeric-owner -C $(ROOTFSDIR) -czf $@ .
