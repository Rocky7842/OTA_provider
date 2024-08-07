#!/bin/bash

if [ -z "$1" ] ; then
    echo "Usage: $0 <ota zip>"
    exit 1
fi

ROM="$1"

FILENAME=$(basename $ROM)
CODENAME=$(echo $FILENAME | cut -f4 -d '-')
DATE=$(echo $FILENAME | cut -f3 -d '-')
SIZE=$(du -b $ROM | cut -f1 -d '	')

METADATA=$(echo $ROM | sed 's/'$FILENAME'/ota_metadata/g' )
TIMESTAMP=$(grep post-timestamp $METADATA | cut -f2 -d '=')

OLDJSON=$(echo $ROM | sed 's/'$FILENAME'/'$CODENAME'.json/g' )
MD5=$(grep md5 "$OLDJSON" | cut -c 12- | sed 's/",//g' )
SHA256=$(grep sha256 "$OLDJSON" | cut -c 15- | sed 's/",//g' )
VERSION=$(grep version "$OLDJSON" | cut -c 16- | sed 's/",//g' )
MAINVERSION=$(echo $VERSION | cut -f1 -d '.')

MAINTAINER="Rocky7842"
PAYPAL="https://www.paypal.com/paypalme/EricRocky7842"
TELEGRAM=""

if [ "$CODENAME" = "d1x" ] ; then
    PROJECT="crdroid-samsung-note10-5g"
    OEM="Samsung"
    DEVICE="Galaxy Note10 5G"
    BUILDTYPE="Monthly"
    FIRMWARE="https://sourceforge.net/projects/firmware-samsung-note10-5g/files/"
    MODEM=""
    BOOTLOADER=""
    DEVICETREE="https://github.com/Rocky7842/android_device_samsung_d1x"
    COMMON_DEVICETREE="https://github.com/Rocky7842/android_device_samsung_exynos9820-common"
    KERNEL="https://github.com/Rocky7842/android_kernel_samsung_exynos9820"
    if [ "$MAINVERSION" = "9" ] ; then
        FORUM="https://xdaforums.com/t/4530391/"
    else
        FORUM=""
    fi
elif [ "$CODENAME" = "grus" ] ; then
    PROJECT="crdroid-xiaomi-9-se"
    OEM="Xiaomi"
    DEVICE="Mi 9 SE"
    BUILDTYPE="Monthly"
    FIRMWARE="https://androidfilehost.com/?fid=2981970449027569929"
    MODEM=""
    BOOTLOADER=""
    DEVICETREE="https://github.com/Rocky7842/android_device_xiaomi_grus"
    COMMON_DEVICETREE="https://github.com/Rocky7842/android_device_xiaomi_sdm710-common"
    KERNEL="https://github.com/Rocky7842/android_kernel_xiaomi_sdm710"
    if [ "$MAINVERSION" = "9" ] ; then
        FORUM="https:/xdaforums.com/t/4533353/"
    elif [ "$MAINVERSION" = "10" ] ; then
        FORUM="https://xdaforums.com/t/4639898/"
    else
        FORUM=""
    fi
elif [ "$CODENAME" = "xmsirius" ] ; then
    PROJECT="crdroid-xiaomi-8-se"
    OEM="Xiaomi"
    DEVICE="Mi 8 SE"
    BUILDTYPE="Monthly"
    FIRMWARE=""
    MODEM=""
    BOOTLOADER=""
    DEVICETREE="https://github.com/Rocky7842/android_device_xiaomi_xmsirius"
    COMMON_DEVICETREE="https://github.com/Rocky7842/android_device_xiaomi_sdm710-common"
    KERNEL="https://github.com/Rocky7842/android_kernel_xiaomi_sdm710"
    if [ "$MAINVERSION" = "9" ] ; then
        FORUM="https://xdaforums.com/t/4535219/"
    elif [ "$MAINVERSION" = "10" ] ; then
        FORUM="https://xdaforums.com/t/4639873/"
    else
        FORUM=""
    fi
elif [ "$CODENAME" = "X01AD" ] ; then
    PROJECT="crdroid-asus-zenfone-max-m2"
    OEM="Asus"
    DEVICE="ZenFone Max M2"
    BUILDTYPE="Monthly"
    FIRMWARE=""
    MODEM=""
    BOOTLOADER=""
    DEVICETREE="https://github.com/Rocky7842/android_device_asus_X01AD"
    COMMON_DEVICETREE=""
    KERNEL="https://github.com/Rocky7842/android_kernel_asus_X01AD"
    if [ "$MAINVERSION" = "10" ] ; then
        FORUM="https://xdaforums.com/t/4643500/"
    else
        FORUM=""
    fi
elif [ "$CODENAME" = "obiwan" ] ; then
    PROJECT="crdroid-asus-rog-phone-3"
    OEM="Asus"
    DEVICE="ROG Phone 3"
    BUILDTYPE="Monthly"
    FIRMWARE=""
    MODEM=""
    BOOTLOADER=""
    DEVICETREE="https://github.com/Rocky7842/android_device_asus_obiwan"
    COMMON_DEVICETREE=""
    KERNEL="https://github.com/Rocky7842/android_kernel_asus_sm8250"
    if [ "$MAINVERSION" = "10" ] ; then
        FORUM="https://xdaforums.com/t/4681840/"
    else
        FORUM=""
    fi
elif [ "$CODENAME" = "psyche" ] ; then
    PROJECT="crdroid-xiaomi-12x"
    OEM="Xiaomi"
    DEVICE="12X"
    BUILDTYPE="Monthly"
    FIRMWARE=""
    MODEM=""
    BOOTLOADER=""
    DEVICETREE="https://github.com/Rocky7842/android_device_xiaomi_psyche"
    COMMON_DEVICETREE="https://github.com/Rocky7842/android_device_xiaomi_sm8250-common"
    KERNEL="https://github.com/Rocky7842/android_kernel_xiaomi_sm8250"
    if [ "$MAINVERSION" = "10" ] ; then
        FORUM="https://xdaforums.com/t/4682358/"
    else
        FORUM=""
    fi
fi

DOWNLOAD="https://sourceforge.net/projects/$PROJECT/files/crdroid-$MAINVERSION/$FILENAME/download"
RECOVERY="https://sourceforge.net/projects/$PROJECT/files/crdroid-$MAINVERSION/recovery.img/download"

if [ "$MAINVERSION" = "9" ] ; then
    GAPPS="https://github.com/MindTheGapps/13.0.0-arm64/releases"
elif [ "$MAINVERSION" = "10" ] ; then
    GAPPS="https://github.com/MindTheGapps/14.0.0-arm64/releases"
else
    GAPPS="https://github.com/MindTheGapps"
fi

response=$(jq -n --arg maintainer "$MAINTAINER" \
        --arg oem "$OEM" \
        --arg device "$DEVICE" \
        --arg filename "$FILENAME" \
        --arg download "$DOWNLOAD" \
        --arg timestamp "$TIMESTAMP" \
        --arg md5 "$MD5" \
        --arg sha256 "$SHA256" \
        --arg size "$SIZE" \
        --arg version "$VERSION" \
        --arg buildtype "$BUILDTYPE" \
        --arg forum "$FORUM" \
        --arg gapps "$GAPPS" \
        --arg firmware "$FIRMWARE" \
        --arg modem "$MODEM" \
        --arg bootloader "$BOOTLOADER" \
        --arg recovery "$RECOVERY" \
        --arg paypal "$PAYPAL" \
        --arg telegram "$TELEGRAM" \
        --arg dt "$DEVICETREE" \
        --arg common-dt "$COMMON_DEVICETREE" \
        --arg kernel "$KERNEL" \
        '$ARGS.named'
)
wrapped_response=$(jq -n --argjson response "[$response]" '$ARGS.named')
echo "$wrapped_response" > crDroid/$MAINVERSION/$CODENAME.json

git pull
git add crDroid/$MAINVERSION/$CODENAME.json
git commit -m "crDroid: $MAINVERSION: $CODENAME: Update autogenerated json to ${DATE}/${TIMESTAMP}"
git push origin main -f

SERVER="rocky7842@frs.sourceforge.net"
echo "login to $SERVER"
rsync -e ssh $ROM $SERVER:/home/frs/project/$PROJECT/crdroid-$MAINVERSION/
