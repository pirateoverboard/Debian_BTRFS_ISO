# Debian_BTRFS_ISO README is a work in progress
Automatic building of a Debian ISO with BTRFS and snapper support

# Clone the repo
`git clone https://github.com/pirateoverboard/Debian_BTRFS_ISO`

`cd Debian_BTRFS_ISO`

# Build the ISO
`sudo ./build_debian net`

# Make bootable USB and boot USB
### Select: Advanced Options
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/1.png)
### Select Expert Install
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/2.png)
# Keep pressing <Enter> key. When you get to partition disks. Then choose Manual
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/3.png)
### Create a new patition table and choose gpt
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/4.png)
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/5.png)
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/6.png)
### Create an EFI system partition
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/7.png)
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/8.png)
### set to 512MB
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/9.png)
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/10.png)
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/11.png)
### Create /boot partition and set to 2GB 
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/12.png)
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/13.png)
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/14.png)
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/15.png)
### set to mount point /boot
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/16.png)
### Craete encrypted volume
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/17.png)
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/18.png)
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/19.png)
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/20.png)
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/21.png)
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/22.png)
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/23.png)
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/24.png)
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/25.png)
# Choose filesystem btrfs and mount point as /
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/26.png)
![image](https://github.com/pirateoverboard/Debian_BTRFS_ISO/blob/main/images/27.png)
