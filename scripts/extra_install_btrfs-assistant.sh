#!/usr/bin/env bash

set -euo pipefail

# Check if script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "You must run this script as root or with sudo."
    exit 1
fi

# Define variables
BTRFS_CONF_PATH="$(realpath btrfs_conf)"
[[ -d "${BTRFS_CONF_PATH}" ]] || BTRFS_CONF_PATH="."
VERSION="2.1"
BTRFS_ASSISTANT_HTTP="archive/${VERSION}/btrfs-assistant-${VERSION}.tar.gz"

# Update package repository
apt-get update

# Install required dependencies
apt-get install -y git cmake fonts-noto qt6-base-dev qt6-base-dev-tools g++ libbtrfs-dev \
            libbtrfsutil-dev pkexec qt6-svg-dev qt6-tools-dev wget

# Download and extract btrfs-assistant
wget -P "${BTRFS_CONF_PATH}/" "https://gitlab.com/btrfs-assistant/btrfs-assistant/-/${BTRFS_ASSISTANT_HTTP}"

tar -xzvf "${BTRFS_CONF_PATH}/btrfs-assistant-${VERSION}.tar.gz" -C "${BTRFS_CONF_PATH}"

# Configure and install btrfs-assistant
cmake -B "${BTRFS_CONF_PATH}/btrfs-assistant-${VERSION}/build" \
      -S "${BTRFS_CONF_PATH}/btrfs-assistant-${VERSION}" \
      -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE='Release'

make -C "${BTRFS_CONF_PATH}/btrfs-assistant-${VERSION}/build"

make -C "${BTRFS_CONF_PATH}/btrfs-assistant-${VERSION}/build" install

snapper -c root create --description "after btrfs-assistant install"

# Clean up
echo "Installation completed. It's safe to remove the directory: sudo rm -rf ${BTRFS_CONF_PATH}/btrfs-assistant-${VERSION}"
