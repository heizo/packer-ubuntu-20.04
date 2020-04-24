#!/bin/bash -eu

echo "==> Disabling apt.daily.service & apt-daily-upgrade.service"
systemctl stop apt-daily.timer apt-daily-upgrade.timer
systemctl mask apt-daily.timer apt-daily-upgrade.timer
systemctl stop apt-daily.service apt-daily-upgrade.service
systemctl mask apt-daily.service apt-daily-upgrade.service
systemctl daemon-reload

echo "==> Updating list of repositories"
apt-get update
if [[ $UPDATE =~ true || $UPDATE =~ 1 ]]; then
    echo "==> Upgrading packages"
    apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
fi
apt-get -y install --no-install-recommends build-essential linux-headers-generic
apt-get -y install --no-install-recommends ssh nfs-common curl git vim

echo "==> Removing the release upgrader"
apt-get -y purge ubuntu-release-upgrader-core
rm -rf /var/lib/ubuntu-release-upgrader
rm -rf /var/lib/update-manager

# Clean up the apt cache
apt-get -y autoremove --purge
apt-get clean

if [[ $DISABLE_IPV6 =~ true || $DISABLE_IPV6 =~ 1 ]]; then
    echo "==> Disabling IPv6"
    sed -i 's/^GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="ipv6.disable=1"/' \
        /etc/default/grub
    #update-grub
fi

# Disable grub boot menu and splash screen
sed -i -e '/^GRUB_TIMEOUT=/aGRUB_RECORDFAIL_TIMEOUT=0' \
    -e 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet nosplash"/' \
    /etc/default/grub
update-grub

# SSH tweaks
echo "UseDNS no" >> /etc/ssh/sshd_config
echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config

echo "====> Shutting down the SSHD service and rebooting..."
systemctl stop sshd.service
nohup shutdown -r now < /dev/null > /dev/null 2>&1 &
sleep 120
exit 0
