#!/bin/bash
set -xe

export LANG=C
export LC_ALL=C

: ${EL_USERNAME=ubuntu}
: ${EL_PASSWORD=embl0w-l4t}
: ${EL_HOSTNAME=jetson}
: ${L4T_RELEASE=r32.4}

cat <<EOF >/etc/apt/apt.conf.d/no-install-recommends
APT::Install-Recommends false;
EOF

apt update
apt dist-upgrade -y
apt install -y systemd systemd-sysv kmod udev dbus busybox wpasupplicant ssh vim-tiny sudo ca-certificates iproute2 iputils-ping python

cat <<EOF >/etc/apt/sources.list.d/nvidia-l4t-apt-source.list
deb https://repo.download.nvidia.com/jetson/common $L4T_RELEASE main
deb https://repo.download.nvidia.com/jetson/t210 $L4T_RELEASE main
EOF

mkdir -p /opt/nvidia/l4t-packages
touch /opt/nvidia/l4t-packages/.nv-l4t-disable-boot-fw-update-in-preinstall

apt update
apt install -y \
        nvidia-l4t-kernel \
        nvidia-l4t-kernel-dtbs \
        nvidia-l4t-bootloader \
        nvidia-l4t-firmware \
        nvidia-l4t-xusb-firmware \
        nvidia-l4t-configs \
        nvidia-l4t-init \
        nvidia-l4t-3d-core

rm -rf /opt/nvidia/l4t-packages

apt install -y \
        xserver-xorg \
        xserver-xorg-legacy \
        xserver-xorg-input-evdev \
        openbox \
        xterm \
        xinit \
        xfonts-base \
        fonts-droid-fallback \
        chromium-browser

useradd -m -s /bin/bash -G adm,disk,input,audio,video,plugdev,netdev,root,tty $EL_USERNAME

echo "$EL_USERNAME:$EL_PASSWORD" | chpasswd

echo "$EL_USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/sudoers

echo "$EL_HOSTNAME" >/etc/hostname

echo "127.0.1.1 $EL_HOSTNAME" >>/etc/hosts

cat <<'EOF' >>/home/$EL_USERNAME/.profile
if test -x /app/ENTRYPOINT -a $(tty) = /dev/tty1; then
        cd /app && ./ENTRYPOINT
fi
EOF

systemctl enable systemd-networkd.service
systemctl disable apt-daily.timer
systemctl disable apt-daily-upgrade.timer

apt-get clean
rm -f /setup.sh
