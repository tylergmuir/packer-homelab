#!/usr/bin/bash

echo '> Cleaning all audit logs ...'
sudo truncate -s 0 /var/log/wtmp
sudo truncate -s 0 /var/log/lastlog
# Cleans persistent udev rules.
echo '> Cleaning persistent udev rules ...'
sudo rm -f /etc/udev/rules.d/70-persistent-net.rules
# Cleans /tmp directories.
echo '> Cleaning /tmp directories ...'
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*
# Cleans apt-get.
echo '> Cleaning apt-get ...'
sudo apt-get clean
sudo apt-get autoremove
# Cleans the machine-id.
echo '> Cleaning the machine-id ...'
sudo truncate -s 0 /etc/machine-id
sudo rm /var/lib/dbus/machine-id
sudo ln -s /etc/machine-id /var/lib/dbus/machine-id
# Cleans shell history.
echo '> Cleaning shell history ...'
sudo rm -f /root/.bash_history
# Cloud Init Nuclear Option
sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
sudo rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg
echo "disable_vmware_customization: false" | sudo tee -a /etc/cloud/cloud.cfg > /dev/null
echo "# to update this file, run dpkg-reconfigure cloud-init
datasource_list: [ VMware, None ]" | sudo tee /etc/cloud/cloud.cfg.d/90_dpkg.cfg > /dev/null
# Set boot options to not override what we are sending in cloud-init
echo '> Modifying grub'
sudo sed -i -e "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/" /etc/default/grub
sudo update-grub 2> /dev/null

sudo sed -i 's/sudo:/# sudo:/g' /etc/cloud/cloud.cfg
sudo cloud-init clean
sudo rm -f /etc/sudoers.d/ubuntu

echo '> Packer Template Build -- Complete'
