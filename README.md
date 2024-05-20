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

# Make bootable USB and boot USB

# QUICK GUIDE
After booting USB, choose Advanced, then Expert install

Configure everything until you get to partitioning

When you get to Partition, choose Manual
- [ ] Configure EFI partition
- [ ] Configure /boot partition
- [ ] Configure Encypted Volumes
- [ ] Change Encryped Volume from ext4 to btrfs
- [ ] Change Encryped Volume mount point to /
- [ ] Commit changes
- [ ] DON'T INSTALL BASE. Instead choose execute a shell
- [ ] run `./cdrom/scripts/build_btrfs_subvols`
- [ ] exit

Install base and configure remaining options

### After first boot, run these commands:
`cd /home`

`sudo ./btrfs_conf/install_snapper_grub-btrfs`

`./btrfs_conf/fix_home.sh`

Optionally, to install btrfs-assistant

`sudo ./btrfs_conf/extra_install_btrfs-assistant.sh`

Finally, if no errors:

`sudo rm -rf /btrfs_conf`

# FULL GUIDE COMING SOON

