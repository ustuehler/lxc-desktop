Multiple Desktop Environments with LXC
======================================

This repository contains a Debian source package which you can build and
install on your host to make it piss simple to run multiple LXC instances with
graphical desktop environments in parallel on a single host.  Each LXC instance
will occupy a separate virtual terminal (VT), so you can switch between them
using Ctrl-Alt-Fn keys.  Each instance also shares direct access to the
graphics hardware and other privileges for performance and flexibility.

This is *no security measure*, but a way to share an expensive resource like a
laptop computer.  Think of isolated work and private environments, or multiple
users.

Quick start on a Ubuntu 14.04 host:

```text
git clone https://github.com/ustuehler/lxc-desktop && cd lxc-desktop
sudo apt-get install ubuntu-dev-tools
dpkg-buildpackage -uc -us
sudo dpkg -i ../lxc-desktop_*_all.deb
sudo apt-get -f install
```

If you want to speed up the creation and updating of the host system and
desktop containers using apt-cacher-ng(8), simply install the lxc-desktop-cache
package.

```text
sudo dpkg -i ../lxc-desktop-cache_*_all.deb
sudo apt-get -f install
```

Now you're ready to create the first desktop container:

```text
sudo lxc-create -n container -t ubuntu-desktop
sudo lxc-start -n container -d
```

Within a few seconds you should get a graphical Ubuntu Desktop login screen
on the next available virtual terminal.
