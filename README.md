Installing
----------

1. Install Ubuntu 14.04 Desktop with disk encryption and LVM option.

Post-Installing
---------------

1. Boot Ubuntu from USB stick.
2. Decrypt root disk.
3. pvscan && lvreduce -L 12g -r ubuntu-vg/root
4. Reboot.

Hardening
---------

1. `echo disable > /proc/acpi/ibm/bluetooth` in /etc/rc.local for Thinkpads (better: udev rule)
2. `sudo ufw enable`
3. `sudo ufw allow 22/tcp`
4. `sudo apt-get install openssh-server`

Containing
----------

1. Install "lxc" package.
2. Set `lxc.bdev.lvm.vg = ubuntu-vg` in /etc/lxc/lxc.conf.
3. Install /etc/lxc/desktop.conf and /etc/lxc/hooks.
4. sudo lxc-create -n container -B lvm --fssize 32G -t ubuntu -f /etc/lxc/desktop.conf
5. sudo lxc-start -n container -d
6. sudo lxc-attach -n container -- apt-get install -y ubuntu-desktop
7. Rename the container's "ubuntu" user in /etc/{passwd,shadow,group} and move /home/ubuntu.
8. In container: `sudo apt-get purge $(dpkg -l | awk '$2 ~ /^plymouth-theme-/ {print $2}')` to avoid whoopsie reports because plymouthd crashes at shutdown. :)

For other desktop containers change "minimum-vt=vtX" in $LXC_ROOTFS_MOUNT/etc/lightdm/lightdm.conf.

Customizing (host and container, optionally)
--------------------------------------------

Change Privacy Settings on host.

Switch Regional Formats to "English (United States)" in Language Support and "Apply System-Wide".

sudo msgfmt -o /usr/share/locale/en/LC_MESSAGES/unity.mo - <<EOF
msgid "Ubuntu Desktop"
msgstr "`hostname`"
EOF
