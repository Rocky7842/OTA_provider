#!/bin/bash

if [ -z "$1" ] ; then
    echo "Usage: $0 <ota zip> upload-file-only=<true or false>"
    exit 1
fi

ROM="$1"
case "$2" in
    "upload-file-only=true"|"upload-file-only=false"|"upload-file-only="|"")
        # Pass argument if valid
        UPLOAD_FILE_ONLY="$2"
        ;;
    *)
        echo "Error: invalid argument: $2"
        exit 1
        ;;
esac

FILENAME=$(basename $ROM)
ROMNAME=$(echo "$FILENAME" | cut -f1 -d '-' )
if [ "$ROMNAME" = "lineage" ] ; then
    bash ./LineageOS/release.sh $ROM $UPLOAD_FILE_ONLY
elif [ "$ROMNAME" = "crDroidAndroid" ] ; then
    bash ./crDroid/release.sh $ROM $UPLOAD_FILE_ONLY
fi

echo "Publish OTA update successfully."
