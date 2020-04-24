#!/bin/bash -eu

SSH_USER=${SSH_USERNAME:-vagrant}

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
    echo "==> Installing VirtualBox guest additions"
    apt-get -y install --no-install-recommends dkms

    VBOX_VERSION=$(cat /home/${SSH_USER}/.vbox_version)
    mount -o loop /home/${SSH_USER}/VBoxGuestAdditions_${VBOX_VERSION}.iso /mnt
    yes | sh /mnt/VBoxLinuxAdditions.run
    umount /mnt
    rm -f /home/${SSH_USER}/VBoxGuestAdditions_${VBOX_VERSION}.iso
    rm -f /home/${SSH_USER}/.vbox_version
fi
