TOPDIR		= $(CURDIR)
BUILDDIR	= $(TOPDIR)/build
L4TTBZ2		= $(BUILDDIR)/l4t.tar.bz2

TAR		= tar --owner 0 --group 0
SUDO		= sudo

L4TURL		= https://developer.nvidia.com/embedded/L4T/r32_Release_v4.3/t210ref_release_aarch64/Tegra210_Linux_R32.4.3_aarch64.tbz2

.PHONY: all clean build upload

all:

clean:
	$(SUDO) rm -rf $(BUILDDIR)

build: $(L4TTBZ2)

upload:
	upload-artifacts.sh firmware $(L4TTBZ2)

$(L4TTBZ2):
	mkdir -p $(BUILDDIR)
	curl -L -o $@ $(L4TURL)
