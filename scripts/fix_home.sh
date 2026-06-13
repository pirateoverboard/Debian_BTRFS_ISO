#!/usr/bin/env bash

set -euo pipefail
trap 'echo "Error in fix_home.sh on line $LINENO" >&2' ERR

if [ "$(id -u)" -ne 0 ]; then
    echo "You must be root or run with sudo."
    exit 1
fi

# Check if required tools are installed
if ! command -v btrfs &> /dev/null || ! command -v snapper &> /dev/null; then
    echo "Error: Required commands 'btrfs' or 'snapper' not found."
    exit 1
fi

TARGET_USER="${TARGET_USER:-}"
if [ -z "$TARGET_USER" ]; then
    TARGET_USER="$(awk -F: '$3 >= 1000 && $3 < 65534 { print $1; exit }' /etc/passwd)"
fi

if [ -z "$TARGET_USER" ]; then
    echo "Error: Could not determine target user. Set TARGET_USER and rerun."
    exit 1
fi

USER_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)
if [ -z "$USER_HOME" ] || [ ! -d "$USER_HOME" ]; then
    echo "Error: Home directory for $TARGET_USER not found."
    exit 1
fi

# Define mount options and volume group
MOUNT_OPTIONS="noatime,space_cache=v2,compress=zstd:1,ssd,discard=async"
GET_UUID="$(awk '$2 == "/" && $1 ~ /^UUID=/ { print $1; exit }' /etc/fstab)"
ROOT_UUID="${GET_UUID#UUID=}"

if [ -n "$ROOT_UUID" ] && [ "$ROOT_UUID" != "$GET_UUID" ]; then
    VOL_GROUP="$(blkid -U "$ROOT_UUID" 2>/dev/null || true)"
else
    VOL_GROUP=$(df / | awk 'NR == 2 { print $1 }')
    ROOT_UUID="$(blkid -s UUID -o value "$VOL_GROUP" 2>/dev/null || true)"
    GET_UUID="UUID=$ROOT_UUID"
fi

if [ -z "$VOL_GROUP" ] || [ -z "$ROOT_UUID" ]; then
    echo "Error: Could not determine Btrfs root device."
    echo "VOL_GROUP=$VOL_GROUP"
    echo "ROOT_UUID=$ROOT_UUID"
    echo "Root fstab entry:"
    awk '$2 == "/" { print }' /etc/fstab || true
    exit 1
fi

# Mount BTRFS root filesystem
mkdir -p /mnt
if mountpoint -q /mnt; then
    umount /mnt
fi
mount -o "$MOUNT_OPTIONS,subvol=/" "$VOL_GROUP" /mnt


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
    if [[ -d "${USER_HOME}/${DIR_NAME}" ]]; then
        mv -v "${USER_HOME}/${DIR_NAME}" "${USER_HOME}/${DIR_NAME}-backup"
    fi
    BTRFS_SUBVOL="$(echo "$USER_HOME/$DIR_NAME" | tr / @)"
    mkdir -p -v "$(dirname "/mnt/${BTRFS_SUBVOL}")"
    btrfs subvolume create "/mnt/${BTRFS_SUBVOL}"
    mkdir -p -v "${USER_HOME}/${DIR_NAME}"
    mount -o "${MOUNT_OPTIONS},subvol=${BTRFS_SUBVOL}" "$VOL_GROUP" "${USER_HOME}/${DIR_NAME}"
    printf "%-41s %-50s %-5s %-s %-s\n" \
        "${GET_UUID}" "${USER_HOME}/${DIR_NAME}" "btrfs" \
        "${MOUNT_OPTIONS},subvol=${BTRFS_SUBVOL}" "0 0" \
        >> /etc/fstab
    if [[ -d "${USER_HOME}/${DIR_NAME}-backup" ]]; then
        cp -ar "${USER_HOME}/${DIR_NAME}-backup/." "${USER_HOME}/${DIR_NAME}"
        rm -rf "${USER_HOME}/${DIR_NAME}-backup"
    fi 
done

# Unmount /mnt and mount all filesystems defined in /etc/fstab
umount /mnt
mount -av

# Ensure correct ownership and permissions for user's home directory
chown -cR "$TARGET_USER":"$TARGET_USER" "${USER_HOME}"
for PRIVATE_DIR in "${USER_HOME}/.gnupg" "${USER_HOME}/.ssh"; do
    [ -d "$PRIVATE_DIR" ] && chmod -vR 0700 "$PRIVATE_DIR"
done

# Install dpkg-pre-post-snapper.sh script
install -m 755 "/home/btrfs_conf/dpkg-pre-post-snapper.sh" "/usr/local/sbin/"

# Configure dpkg to invoke snapper before and after package operations
echo 'DPkg::Pre-Invoke { "/usr/local/sbin/dpkg-pre-post-snapper.sh pre"; };' > /etc/apt/apt.conf.d/80snapper
echo 'DPkg::Post-Invoke { "/usr/local/sbin/dpkg-pre-post-snapper.sh post"; };' >> /etc/apt/apt.conf.d/80snapper

# Create snapper snapshots
snapper --no-dbus -c home create --description "default fresh install"
snapper --no-dbus -c root create --description "default fresh install"
echo
echo
echo "If you want to install btrfs-assistant you can run: sudo ./extra_install_btrfs-assistant.sh"
echo "If no errors, it's safe to remove: sudo rm -rf /home/btrfs_conf"
