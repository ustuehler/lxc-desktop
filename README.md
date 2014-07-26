Installing
----------

1. Install Ubuntu 14.04 Desktop with disk encryption and LVM option.

Post-Installing
---------------

1. Boot Ubuntu from USB stick.
2. Decrypt root disk.
3. pvscan && lvreduce -L 12g -r ubuntu-vg/root
4. Reboot.

Hardening (Optional)
--------------------

Disable Bluetooth on the host system:

    class { '::lxc_desktop::host':
      kill_bluetooth => true
    }

Allow incoming connections via SSH and reject *all* outgoing traffic:

    class { '::lxc_desktop::host':
      ufw_enable     => true,
      ufw_allow_in   => ['ssh/tcp'],
      ufw_allow_out  => ['domain/udp', 'ssh/tcp', '8140/tcp'],
      ufw_reject_out => true
    }

Containing
----------

1. Install "lxc" package.
2. Set `lxc.bdev.lvm.vg = ubuntu-vg` in /etc/lxc/lxc.conf.
4. sudo lxc-create -n container -B lvm --fssize 32G -t ubuntu -f /etc/lxc/desktop.conf
5. sudo lxc-start -n container -d
6. sudo lxc-attach -n container -- apt-get install -y ubuntu-desktop
7. Rename the container's "ubuntu" user in /etc/{passwd,shadow,group} and move /home/ubuntu.
8. In container: `sudo apt-get purge $(dpkg -l | awk '$2 ~ /^plymouth-theme-/ {print $2}')` to avoid whoopsie reports because plymouthd crashes at shutdown. :)

For other desktop containers change `minimum-vt=vtX` in $LXC\_ROOTFS\_MOUNT/etc/lightdm/lightdm.conf.

Customizing (host and container, optionally)
--------------------------------------------

Change Privacy Settings on host.

Switch Regional Formats to "English (United States)" in Language Support and "Apply System-Wide".

    sudo msgfmt -o /usr/share/locale/en/LC_MESSAGES/unity.mo - <<EOF
    msgid "Ubuntu Desktop"
    msgstr "`hostname`"
    EOF
