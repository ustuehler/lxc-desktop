Multiple Desktop Environments with LXC
======================================

This repository contains instructions for running multiple LXC instances with
graphical desktop environments in parallel on a single host.  Each LXC instance
will occupy a separate virtual terminal (VT), so you can switch between them
using Ctrl-Alt-Fn keys.

Quick start on a Ubuntu 14.04 host with Ansible 1.6 or greater installed:

```text
git clone https://github.com/ustuehler/lxc-desktop && cd lxc-desktop
sudo ansible-playbook -i inventory -l localhost -c local site.yml
```

See the full instructions below for some playbook variables that you may wish
to tweak.

Who Would Want This?
--------------------

Imagine you could have as many laptops as you wish: one for every project you
work on, one for your professional work and some others for entertainment, kids
and guests.  You could keep private data physically separated and if you lost
one of them, you'd still have all the others.  You could also encrypt, backup,
restore and upgrade each of them individually.

Of course, it would be extremely inconvenient to carry around and maintain that
many laptops, so the question is how close we can get to that ideal with just a
single laptop.  Companies may put virtual machines on their employee's laptops
to allow them to better isolate work and private use of the equipment.  That's
a handy solution and believed by some to be fairly secure (*caugh*), but VMs
can add noticable overhead, meaning fewer hours on battery, more fan noise and
degraded performance due to loss of hardware acceleration.  If all your laptops
would run Linux anyway and you don't think that VMs would provide much better
security, you can trade the isolation of VMs against the performance of Linux
containers with direct hardware access.

Installing The Host Operationg System
-------------------------------------

1. Prepare a bootable USB stick or other installation media with Ubuntu 14.04
   Desktop on it.
2. Install a "minimal" system without extras but with *full disk encryption*
   and the *LVM option* enabled.  Go ahead and use the whole disk; we'll free
   up space in the main LVM volume group afterwards.
3. Once the installation is complete, boot the Ubuntu live enviroment from USB
   stick again.
4. Decrypt the installed disk from the desktop of the live environment.
5. Resize the main volume group to 12 GB, for example.  To do this run `pvscan
   && lvreduce -L 12g -r ubuntu-vg/root` as root user in a terminal.
6. Remove the boot media and reboot again to boot from the encrypted disk.

Post-Installation Steps
-----------------------

1. Enable backports: https://help.ubuntu.com/community/UbuntuBackports
2. Run `sudo apt-get update && sudo apt-get dist-upgrade` to make sure that you
   will have the latest version of the `lxc` package installed later on. There
   was a runtime linking problem with liblxc.so which was fixed in Ubuntu after
   14.04 was out.
3. Install Ansible from backports (because the "ufw" module is only available
   since Ansible 1.6): `sudo apt-get install ansible/trusty-backports`
4. Install Git and clone this repository: `sudo apt-get install git && git
   clone https://github.com/ustuehler/lxc-desktop && cd lxc-desktop`
5. Run this playbook as root: `sudo ansible-playbook -i inventory
   -l localhost -c local site.yml`

Playbook Variables
------------------

You can pass variables to `ansible-playbook` with the `-e` option, e.g.  `sudo
ansible-playbook -i inventory -l localhost -c local -e manage_ufw=true
site.yml`.

* `kill_bluetooth`: When `true`, disable any Bluetooth HCI devices as soon as
  they are detected by udev.  This is for people who don't trust or don't use
  their built-in Bluetooth HCI and would rather have it disabled at all times.
  Default: `false`

* `manage_ufw`: When`true`, install and enable the Uncomplicated Firewall
  (UFW).  The default policy will be to reject outgoing traffic from the LXC
  host itself and to drop all incoming traffic by default.  Exceptional rules
  can be defined in the file `roles/host/tasks/ufw.yml`.  Default: `false`

Creating Desktop LXC Instances
------------------------------

1. Set `lxc.bdev.lvm.vg = ubuntu-vg` in `/etc/lxc/lxc.conf`. (optional)
2. `sudo lxc-create -n container -B lvm --vgname ubuntu-vg --fssize 32G -t ubuntu -f /etc/lxc/desktop.conf`
3. `sudo lxc-start -n container -d`
4. `sudo lxc-attach -n container -- apt-get install -y ubuntu-desktop`
5. Rename the container's "ubuntu" user in `/etc/{passwd,shadow,group}` and move `/home/ubuntu`. (optional)
6. In container: `sudo apt-get purge $(dpkg -l | awk '$2 ~ /^plymouth-theme-/ {print $2}')` to avoid whoopsie reports because plymouthd crashes at shutdown. :)
7. For the second and later desktop instances change `minimum-vt=vtX` in `$LXC_ROOTFS_MOUNT/etc/lightdm/lightdm.conf`.
8. Optionally display the LXC instance's hostname in Unity.

        sudo msgfmt -o /usr/share/locale/en/LC_MESSAGES/unity.mo - <<EOF
        msgid "Ubuntu Desktop"
        msgstr "`hostname`"
        EOF
