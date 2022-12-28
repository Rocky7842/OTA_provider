#!/bin/bash

if [ -z "$1" ] ; then
    echo "Usage: $0 <ota zip> <json of the build>"
    exit 1
fi

ROM="$1"
OLDJSON="$2"

METADATA=$(unzip -p "$ROM" META-INF/com/android/metadata)
SDK_LEVEL=$(echo "$METADATA" | grep post-sdk-level | cut -f2 -d '=')
TIMESTAMP=$(echo "$METADATA" | grep post-timestamp | cut -f2 -d '=' | cut -f1 -d '-' )

FILENAME=$(basename $ROM)
DEVICE=$(echo $FILENAME | cut -f4 -d '-')
DATE=$(echo $FILENAME | cut -f3 -d '-')
SIZE=$(du -b $ROM | cut -f1 -d '	')

MD5=$(grep md5 "$OLDJSON" | cut -c 12- | sed 's/",//g' )
SHA256=$(grep sha256 "$OLDJSON" | cut -c 15- | sed 's/",//g' )
VERSION=$(grep version "$OLDJSON" | cut -c 16- | sed 's/",//g' )
MAINVERSION=$(echo $VERSION | cut -c 1)

if [ "$DEVICE" = "d1x" ] ; then
    PROJECT="crdroid-samsung-note10-5g"

    response=$(jq -n --arg maintainer "Rocky7842" \
            --arg oem "Samsung" \
            --arg device "Galaxy Note10 5G" \
            --arg filename $FILENAME \
            --arg download "https://sourceforge.net/projects/$PROJECT/files/crdroid-9/$FILENAME/download" \
            --arg timestamp $TIMESTAMP \
            --arg md5 $MD5 \
            --arg sha256 $SHA256 \
            --arg size $SIZE \
            --arg version $VERSION \
            --arg buildtype "Monthly" \
            --arg forum "https://forum.xda-developers.com/t/4530391/" \
            --arg gapps "http://downloads.codefi.re/jdcteam/javelinanddart/gapps" \
            --arg firmware "https://sourceforge.net/projects/firmware-samsung-note10-5g/files/" \
            --arg modem "" \
            --arg bootloader "" \
            --arg recovery "https://sourceforge.net/projects/$PROJECT/files/crdroid-9/recovery.img/download" \
            --arg paypal "" \
            --arg telegram "" \
            --arg dt "https://github.com/Rocky7842/android_device_samsung_d1x" \
            --arg common-dt "https://github.com/Rocky7842/android_device_samsung_exynos9820-common" \
            --arg kernel "https://github.com/Rocky7842/android_kernel_samsung_exynos9820" \
            '$ARGS.named'
    )
elif [ "$DEVICE" = "grus" ] ; then
    PROJECT="crdroid-xiaomi-9-se"

    response=$(jq -n --arg maintainer "Rocky7842" \
            --arg oem "Xiaomi" \
            --arg device "Mi 9 SE" \
            --arg filename $FILENAME \
            --arg download "https://sourceforge.net/projects/$PROJECT/files/crdroid-9/$FILENAME/download" \
            --arg timestamp $TIMESTAMP \
            --arg md5 $MD5 \
            --arg sha256 $SHA256 \
            --arg size $SIZE \
            --arg version $VERSION \
            --arg buildtype "Monthly" \
            --arg forum "https://forum.xda-developers.com/t/4533353/" \
            --arg gapps "http://downloads.codefi.re/jdcteam/javelinanddart/gapps" \
            --arg firmware "https://androidfilehost.com/?fid=2981970449027569929" \
            --arg modem "" \
            --arg bootloader "" \
            --arg recovery "https://sourceforge.net/projects/$PROJECT/files/crdroid-9/recovery.img/download" \
            --arg paypal "" \
            --arg telegram "" \
            --arg dt "https://github.com/Rocky7842/android_device_xiaomi_grus" \
            --arg common-dt "" \
            --arg kernel "https://github.com/Rocky7842/android_kernel_xiaomi_sdm710" \
            '$ARGS.named'
    )
fi

wrapped_response=$(jq -n --argjson response "[$response]" '$ARGS.named')
echo "$wrapped_response" > crDroid/$MAINVERSION/$DEVICE.json

git add crDroid/$MAINVERSION/$DEVICE.json
git commit -m "crDroid: Update autogenerated json for $DEVICE $MAINVERSION ${DATE}/${TIMESTAMP}"
git push origin main -f

SERVER="rocky7842@frs.sourceforge.net"
echo "login to $SERVER"
rsync -e ssh $ROM $SERVER:/home/frs/project/$PROJECT/crdroid-$MAINVERSION/
