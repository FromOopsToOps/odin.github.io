#!/bin/bash

while true
	do
	battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`
	if [ $battery_level -le 20 && $battery_level -gt 7 ]; then
		notify-send --urgency=normal "Battery Low" "Level: ${battery_level}%"
	elif [ $battery_level -le 7 ]; then
		notify-send --urgency=critical "Battery VERY low" "Level: ${battery_level}%"
	fi
done
