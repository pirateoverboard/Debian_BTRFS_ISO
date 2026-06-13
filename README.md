# Debian_BTRFS_ISO
Automatic building of a Debian ISO with BTRFS and snapper support

# Clone the repo
`git clone https://github.com/pirateoverboard/Debian_BTRFS_ISO`

`cd Debian_BTRFS_ISO`

# Install dependencies
`sudo apt install xorriso aria2c curl gpg`

# Build the ISO
For a debian net install, use:

`sudo ./build_debian net`

For a debian DVD full install, use:

`sudo ./build_debian full`

# Info:
the build_debian command with build a debian ISO: debian-<version>-amd64-<DVD/netinst>-btrfs-modified.iso

# Build the Debian Installer udeb
To build only the installer component:

`./build_udeb`

This creates `dist/debian-btrfs-iso-udeb_<version>_all.udeb`. The udeb installs
the BTRFS subvolume setup hook into `partman` and carries the post-install
Snapper helper scripts inside the installer environment.

# Make bootable USB and boot USB

# QUICK GUIDE
After booting USB, choose Advanced, then Expert install.

Use the installer defaults until you get to partitioning.

When you get to Partition, choose Manual:
- [ ] Configure EFI partition
- [ ] Configure /boot partition
- [ ] Configure encrypted volume if wanted
- [ ] Select the root filesystem entry, set it to BTRFS, then set Mount point to /
- [ ] Do not create separate /home, /var, /opt, or /srv partitions
- [ ] Commit changes

Continue the installer normally.

The preseed late command runs the Snapper, grub-btrfs, and home subvolume setup
before the installer finishes.

# FULL GUIDE COMING SOON
