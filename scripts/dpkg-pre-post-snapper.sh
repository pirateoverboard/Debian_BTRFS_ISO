#!/bin/bash
# script source https://gist.github.com/imthenachoman/f722f6d08dfb404fed2a3b2d83263118
# this script is an enhancement of https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=770938

# we need to work up the process tree to find the apt command that triggered the call to this script
# get the initial PID

PID=$$

# find the apt command by working up the process tree
# loop until
# - PID is empty
# - PID is 1
# - or PID command is apt
while [[ -n "$PID" && "$PID" != "1" && "$(ps -ho comm "${PID}")" != "apt" ]] ; do
    # the current PID is not the apt command so go up one by getting the parent PID of hte current PID
    PID=$(ps -ho ppid "$PID" | xargs)
done

SNAPPER_DESCRIPTION="apt"

# assuming we found the apt command, get the full args
if [[ "$(ps -ho comm "${PID}")" = "apt" ]] ; then
    SNAPPER_DESCRIPTION="$(ps -ho args "${PID}")"
fi

# main event

# source /etc/default/snapper if it exists
if [ -e /etc/default/snapper ] ; then
    . /etc/default/snapper
fi

# what action are we taking
if [ "$1" = "pre" ] ; then
    # pre, so take a pre snapshot

    # if snapper is installed
    # and if snapper snapshots are not being disabled using the DISABLE_APT_SNAPSHOT variable
    # and if /etc/snapper/configs/root exists
    if [ -x /usr/bin/snapper ] && [ ! x$DISABLE_APT_SNAPSHOT = 'xyes' ] && [ -e /etc/snapper/configs/root ] ; then
        # delete any lingering temp files
        rm -f /var/tmp/snapper-apt || true

        # create a snapshot
        # and save the snapshot number for reference later
        snapper create -d "${SNAPPER_DESCRIPTION}" -c number -t pre -p > /var/tmp/snapper-apt || true

        # clean up snapper
        snapper cleanup number || true
    fi
elif [ "$1" = "post" ] ; then
    # post, so take a post snapshot

    # if snapper is installed
    # and if snapper snapshots are not being disabled using the DISABLE_APT_SNAPSHOT variable
    # and if the temp file with the snapshot number from the pre snapshot exists
    if [ -x /usr/bin/snapper ] && [ ! x$DISABLE_APT_SNAPSHOT = 'xyes' ] && [ -e /var/tmp/snapper-apt ]
    then
        # take a post snapshot and link it to the # of the pre snapshot
        snapper create -d "${SNAPPER_DESCRIPTION}" -c number -t post --pre-number=`cat /var/tmp/snapper-apt` || true

        # clean up snapper
        snapper cleanup number || true
    fi
fi