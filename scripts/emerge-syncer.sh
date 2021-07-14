#!/bin/bash

# emerge syncer
#
# Automatically sync emerge database and repositories
# supports both layman and emaint.
# Supports only systemd logging though.

# warning journal of what we are doing

echo "Starting Emerge Syncer" |systemd-cat -t emerge-sync -p info
emerge --sync
status=$?
[ $status == '0' ] && echo "Emerge successfully updated database." |systemd-cat -t emerge-sync -p info || echo "Emerge sync failed. Will attempt to sync repositories." systemd-cat -t emerge-sync -p warning

# testing what we have:
if ! command -v layman &> /dev/null
	then
		echo "Layman not installed, trying emaint" |systemd-cat -t emerge-sync -p info
		emaint sync -A
		status=$?
		[ $status == '0' ] && echo "Emaint successfully updated repository database." |systemd-cat -t emerge-sync -p info || echo "Emaint couldn\'t update repository database." |systemd-cat -t emerge-sync -p warning
	exit
	else
		layman -S
		status=$?
                [ $status == '0' ] && echo "Layman successfully updated repository database." |systemd-cat -t emerge-sync -p info || echo "All attempts of updating database failed. Please solve manually." |systemd-cat -t emerge-sync -p emerg
	exit
fi
