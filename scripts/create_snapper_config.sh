#!/bin/sh

set -e

while read -r CONFIG PATHNAME; do
	[ -n "$CONFIG" ] || continue
	if [ -f "/etc/snapper/configs/$CONFIG" ]; then
		echo "Skipping existing snapper config: $CONFIG"
		continue
	fi
	snapper --no-dbus -c "$CONFIG" create-config "$PATHNAME"
	echo "snapper --no-dbus -c $CONFIG create-config $PATHNAME"
done <<'END'
root /
home /home
VMs /var/lib/libvirt/images
podman /var/lib/containers
docker /var/lib/docker
opt /opt
local /usr/local
srv /srv
www /var/www
END
