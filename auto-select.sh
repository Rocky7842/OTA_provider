#!/bin/bash

if [ -z "$1" ] ; then
    echo "Usage: $0 <ota zip>"
    exit 1
fi

ROM="$1"

FILENAME=$(basename $ROM)
ROMNAME=$(echo "$FILENAME" | cut -f1 -d '-' )
if [ "$ROMNAME" = "lineage" ] ; then
    sh ./LineageOS/release.sh $ROM
elif [ "$ROMNAME" = "crDroidAndroid" ] ; then
    sh ./crDroid/release.sh $ROM
fi

echo "Publish OTA update successfully."
