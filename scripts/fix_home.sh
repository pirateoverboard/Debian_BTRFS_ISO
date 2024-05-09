#!/usr/bin/env bash

set -euo pipefail

if [ "$(id -u)" -eq 0 ]; then
    echo "Do not run this script as root."
    exit 1
fi

# Check if required tools are installed
if ! command -v btrfs &> /dev/null || ! command -v snapper &> /dev/null; then
    echo "Error: Required commands 'btrfs' or 'snapper' not found."
    exit 1
fi

# Get user's home directory
USER_HOME=$(getent passwd "$USER" | cut -d: -f6)

# Define mount options and volume group
MOUNT_OPTIONS="noatime,space_cache=v2,compress=zstd:1,ssd,discard=async"
VOL_GROUP=$(df | awk '/\/dev\/mapper/{print $1;exit}')
GET_UUID=$(sudo blkid | awk '/\/dev\/mapper/{print $2;exit}' | sed 's/"//g')

# Mount BTRFS root filesystem
sudo mount -o "$MOUNT_OPTIONS,subvol=/" "$VOL_GROUP" /mnt


# Define and create subvolumes
DIR_NAMES=(
    ".mozilla" \
    ".config/google-chrome" \
    ".config/chromium" \
    ".gnupg" \
    ".ssh" \
    ".thunderbird" \
    ".config/evolution"
)

for DIR_NAME in "${DIR_NAMES[@]}"; do
    BTRFS_SUBVOL="$(echo "$USER_HOME/$DIR_NAME" | tr / @)"
    sudo btrfs subvolume create "/mnt/${BTRFS_SUBVOL}"
    sudo mkdir -p -v "${USER_HOME}/${DIR_NAME}"
    sudo mount -o "${MOUNT_OPTIONS},subvol=${BTRFS_SUBVOL}" "$VOL_GROUP" "${USER_HOME}/${DIR_NAME}"
    printf "%-41s %-50s %-5s %-s %-s\n" \
        "${GET_UUID}" "${USER_HOME}/${DIR_NAME}" "btrfs" \
        "${MOUNT_OPTIONS},subvol=${BTRFS_SUBVOL}" "0 0" \
        | sudo tee -a /etc/fstab > /dev/null
done

# Reload systemd to pick up fstab changes
sudo systemctl daemon-reload

# Unmount /mnt and mount all filesystems defined in /etc/fstab
sudo umount /mnt
sudo mount -av

# Ensure correct ownership and permissions for user's home directory
sudo chown -cR "$USER":"$USER" "${USER_HOME}"
sudo chmod -vR 0700 "${USER_HOME}/"{.gnupg,.ssh}

# Install dpkg-pre-post-snapper.sh script
sudo install -m 755 "/home/btrfs_conf/dpkg-pre-post-snapper.sh" "/usr/local/sbin/"

# Configure dpkg to invoke snapper before and after package operations
echo 'DPkg::Pre-Invoke { "/usr/local/sbin/dpkg-pre-post-snapper.sh pre"; };' | sudo tee /etc/apt/apt.conf.d/80snapper
echo 'DPkg::Post-Invoke { "/usr/local/sbin/dpkg-pre-post-snapper.sh post"; };' | sudo tee -a /etc/apt/apt.conf.d/80snapper

# Create snapper snapshots
sudo snapper -c home create --description "default fresh install"
sudo snapper -c root create --description "default fresh install"

echo "If no errors, it's safe to remove: sudo -rf /home/btrfs_conf"
