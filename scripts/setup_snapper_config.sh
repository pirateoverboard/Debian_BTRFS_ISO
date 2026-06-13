#!/bin/sh

set -e

while read -r CONFIG PATHNAME; do
	[ -n "$CONFIG" ] || continue
	for OPTION in \
		TIMELINE_CREATE=no \
		ALLOW_GROUPS=sudo \
		SYNC_ACL=yes \
		NUMBER_LIMIT=10 \
		NUMBER_LIMIT_IMPORTANT=10
	do
		snapper --no-dbus -c "$CONFIG" set-config "$OPTION"
		echo "snapper --no-dbus -c $CONFIG set-config $OPTION"
	done
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
