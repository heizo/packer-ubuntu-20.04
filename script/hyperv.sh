#!/bin/bash -eu

if [[ $PACKER_BUILDER_TYPE =~ hyperv ]]; then
    rm -f /etc/netplan/99-packer.yaml
fi
