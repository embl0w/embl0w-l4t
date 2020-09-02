#!/bin/bash
set -xe

: ${EL_USERNAME=ubuntu}
: ${EL_HOMEDIR=/home/$EL_USERNAME}

chmod 0600 /etc/ssh/ssh_host_*_key

mkdir $EL_HOMEDIR/.ssh
cp /ssh/id_rsa.pub $EL_HOMEDIR/.ssh/authorized_keys
chown $EL_USERNAME.$EL_USERNAME -R $EL_HOMEDIR/.ssh
rm -rf /ssh

echo "PasswordAuthentication no" >>/etc/ssh/sshd_config

ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

apt-get clean
rm -f /setup.sh
