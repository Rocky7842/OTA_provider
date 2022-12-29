#!/bin/bash

if [ -z "$1" ] ; then
    echo "Usage: $0 <ota zip>"
    exit 1
fi

ROM="$1"

METADATA=$(unzip -p "$ROM" META-INF/com/android/metadata)
SDK_LEVEL=$(echo "$METADATA" | grep post-sdk-level | cut -f2 -d '=')
TIMESTAMP=$(echo "$METADATA" | grep post-timestamp | cut -f2 -d '=')

FILENAME=$(basename $ROM)
CODENAME=$(echo $FILENAME | cut -f5 -d '-' | cut -f1 -d".")
ROMTYPE=$(echo $FILENAME | cut -f4 -d '-')
DATE=$(echo $FILENAME | cut -f3 -d '-')
ID=$(echo ${TIMESTAMP}${CODENAME}${SDK_LEVEL} | sha256sum | cut -f 1 -d ' ')
SIZE=$(du -b $ROM | cut -f1 -d '	')
TYPE=$(echo $FILENAME | cut -f4 -d '-')
VERSION=$(echo $FILENAME | cut -f2 -d '-')

if [ "$CODENAME" = "d1x" ] ; then
    PROJECT="lineageos-samsung-note10-5g"
fi

URL="https://sourceforge.net/projects/$PROJECT/files/lineage-${VERSION}/${FILENAME}/download"

response=$(jq -n --arg datetime $TIMESTAMP \
        --arg filename $FILENAME \
        --arg id $ID \
        --arg romtype $ROMTYPE \
        --arg size $SIZE \
        --arg url $URL \
        --arg version $VERSION \
        '$ARGS.named'
)
wrapped_response=$(jq -n --argjson response "[$response]" '$ARGS.named')
echo "$wrapped_response" > LineageOS/$VERSION/$CODENAME.json

git add LineageOS/$VERSION/$CODENAME.json
git commit -m "LineageOS: $VERSION: $CODENAME: Update autogenerated json to ${DATE}/${TIMESTAMP}"
git push origin main -f

SERVER="rocky7842@frs.sourceforge.net"
echo "login to $SERVER"
rsync -e ssh $ROM $SERVER:/home/frs/project/$PROJECT/lineage-$VERSION/
