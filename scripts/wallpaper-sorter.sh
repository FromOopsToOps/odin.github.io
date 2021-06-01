#!/bin/bash

# set variables here!
WALLPAPER_FOLDER="$HOME/Imagens/Wallpapers"
16-9="Desktop-FullHD"
4-3="Desktop-TV"
mobile="Mobile"
square="Desktop-Square"
wide="Desktop-Wide"
nonwide="Desktop-NonWide"
IMAGE_EXTENSION='\.jpg$|\.webp$|\.png$|\.jpeg$|\.bmp$'

# Prepare a list of the files to edit
cd "$WALLPAPER_FOLDER"

find $(pwd) -maxdepth 1 -type f -exec file {} \; |cut -d':' -f1  | egrep "$IMAGE_EXTENSION" > /tmp/image-list.txt

# read each line of the list and edit
while IFS= read -r line; do

	# get file with full path from the list
	FILE="$line"

	# identify geometry and store as variables
	X=$(identify "$FILE"|awk '{print $(NF-6)}'|cut -d'x' -f1)
	Y=$(identify "$FILE"|awk '{print $(NF-6)}'|cut -d'x' -f2)
	RATIO=$(awk "BEGIN {print $X/$Y}")

	case $RATIO in
		1.77778)
			mv "$line" "$WALLPAPER_FOLDER"/"$16-9"
			;;
		1.33333)
			mv "$line" "$WALLPAPER_FOLDER"/"$4-3"
			;;
		0.5625)
			mv "$line" "$WALLPAPER_FOLDER"/"$mobile"
			;;
		1)
			mv "$line" "$WALLPAPER_FOLDER"/"$square"
			;;
		*)
			if [ $RATIO -gt 1 ]
			then
				mv "$line" "$WALLPAPER_FOLDER"/"$wide"
			else
				mv "$line" "$WALLPAPER_FOLDER"/"$nonwide"
			fi
			;;
	esac

done < /tmp/image-list.txt

# remove the list at last
rm /tmp/image-list.txt
