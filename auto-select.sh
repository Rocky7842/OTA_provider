#!/bin/bash

if [ -z "$1" ] ; then
    echo "Usage: $0 <ota zip> <optional:json of the build>"
    exit 1
fi

ROM="$1"
OLDJSON="$2"

FILENAME=$(basename $ROM)

ROMNAME=$(echo "$FILENAME" | cut -f1 -d '-' )

if [ "$ROMNAME" = "lineage" ] ; then
    sh ./LineageOS/release.sh $ROM
elif [ "$ROMNAME" = "crDroidAndroid" ] ; then
    sh ./crDroid/release.sh $ROM $OLDJSON
fi
