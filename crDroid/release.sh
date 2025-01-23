#!/bin/bash

if [ -z "$1" ] ; then
    echo "Usage: $0 <ota zip>"
    exit 1
fi

ROM="$1"
ROM_DIR=$(dirname "$ROM")

ROMFILENAME=$(basename $ROM)
CODENAME=$(echo $ROMFILENAME | cut -f4 -d '-')
DATE=$(echo $ROMFILENAME | cut -f3 -d '-')
SIZE=$(du -b $ROM | cut -f1 -d '	')

ANDROID_VERSION=$(echo $ROMFILENAME | cut -f2 -d '-')
if [ "${ANDROID_VERSION##*.}" -eq 0 ]; then
    ANDROID_VERSION="${ANDROID_VERSION%.*}"
    ANDROID_MAINVERSION=$ANDROID_VERSION
    ANDROID_MINORVERSION="0"
else
    ANDROID_MAINVERSION="${ANDROID_VERSION%.*}"
    ANDROID_MINORVERSION="${ANDROID_VERSION#*.}"
fi

METADATA=$(echo $ROM | sed 's/'$ROMFILENAME'/ota_metadata/g' )
TIMESTAMP=$(grep post-timestamp $METADATA | cut -f2 -d '=')

OLDJSON=$(echo $ROM | sed 's/'$ROMFILENAME'/'$CODENAME'.json/g' )
MD5=$(jq -r '.response[0].md5' "$OLDJSON")
SHA256=$(jq -r '.response[0].sha256' "$OLDJSON")
VERSION=$(jq -r '.response[0].version' "$OLDJSON")
MAINVERSION=$(echo $VERSION | cut -f1 -d '.')

MAINTAINER="Rocky7842"
PAYPAL="https://www.paypal.com/paypalme/EricRocky7842"
TELEGRAM=""
# Remember to also setup GITHUB_ACCESS_TOKEN for use in the script!

RECOVERY_IN_BOOT=false

if [ "$CODENAME" = "d1x" ] ; then
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
    elif [ "$MAINVERSION" = "10" ] ; then
        FORUM="https://xdaforums.com/t/4655791/"
    elif [ "$MAINVERSION" = "11" ] ; then
        FORUM="https://xdaforums.com/t/4714396/"
    else
        FORUM=""
    fi
elif [ "$CODENAME" = "grus" ] ; then
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
    elif [ "$MAINVERSION" = "11" ] ; then
        FORUM="https://xdaforums.com/t/4714612/"
    else
        FORUM=""
    fi
elif [ "$CODENAME" = "xmsirius" ] ; then
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
    elif [ "$MAINVERSION" = "11" ] ; then
        FORUM="https://xdaforums.com/t/4714901/"
    else
        FORUM=""
    fi
elif [ "$CODENAME" = "X01AD" ] ; then
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
    elif [ "$MAINVERSION" = "11" ] ; then
        FORUM="https://xdaforums.com/t/4706424/"
    else
        FORUM=""
    fi
elif [ "$CODENAME" = "obiwan" ] ; then
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

    RECOVERY_IN_BOOT=true
elif [ "$CODENAME" = "renoir" ] ; then
    OEM="Xiaomi"
    DEVICE="Mi 11 Lite 5G"
    BUILDTYPE="Monthly"
    FIRMWARE=""
    MODEM=""
    BOOTLOADER=""
    DEVICETREE="https://github.com/Rocky7842/android_device_xiaomi_renoir"
    COMMON_DEVICETREE="https://github.com/Rocky7842/android_device_xiaomi_sm8350-common"
    KERNEL="https://github.com/Rocky7842/android_kernel_xiaomi_sm8350"
    if [ "$MAINVERSION" = "10" ] ; then
        FORUM="https://xdaforums.com/t/4702507/"
    else
        FORUM=""
    fi

    RECOVERY_IN_BOOT=true
fi

TAG="$CODENAME-crDroid-$VERSION-$DATE"

DOWNLOAD="https://github.com/$MAINTAINER/OTA_provider/releases/download/$TAG/$ROMFILENAME"
RECOVERY_DOWNLOAD="https://github.com/$MAINTAINER/OTA_provider/releases/download/$TAG/recovery.img"

GAPPS="https://github.com/MindTheGapps/${ANDROID_MAINVERSION}.${ANDROID_MINORVERSION}.0-arm64/releases"

response=$(jq -n --arg maintainer "$MAINTAINER" \
        --arg oem "$OEM" \
        --arg device "$DEVICE" \
        --arg filename "$ROMFILENAME" \
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
        --arg recovery "$RECOVERY_DOWNLOAD" \
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
git tag -d $TAG
git tag $TAG
git push origin main -f

RELEASE_RESPONSE=$(curl -s -H "Authorization: token $GITHUB_ACCESS_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "tag_name": "'"$TAG"'",
       "target_commitish": "main",
       "name": "'"${ROMFILENAME%.zip}"'",
       "body": "ROM: crDroid<br>Codename: '"$CODENAME"'<br>Device: '"$DEVICE"' <br>crDroid version: '"$MAINVERSION"' <br>Android version: '"$ANDROID_VERSION"' <br>Variant: VANILLA",
       "draft": false,
       "prerelease": false
     }' \
     https://api.github.com/repos/$MAINTAINER/OTA_provider/releases)

echo ""
echo "------Release posted------"
echo ""

RELEASE_ID=$(echo "$RELEASE_RESPONSE" | jq -r .id)
UPLOAD_URL="https://uploads.github.com/repos/$MAINTAINER/OTA_provider/releases/$RELEASE_ID/assets"

curl -H "Authorization: token $GITHUB_ACCESS_TOKEN" \
     -H "Content-Type: application/octet-stream" \
     -T "$ROM" \
     "$UPLOAD_URL?name=$ROMFILENAME"

echo ""
echo "------ROM uploaded------"
echo ""

if [ "$RECOVERY_IN_BOOT" = false ] ; then
    RECOVERY="${ROM_DIR}/recovery.img"
    FILES="$RECOVERY"
else
    BOOT="${ROM_DIR}/boot.img"
    VENDOR_BOOT="${ROM_DIR}/vendor_boot.img"
    DTBO="${ROM_DIR}/dtbo.img"
    FILES="$BOOT $VENDOR_BOOT $DTBO"
fi

for FILE in $FILES; do
    FILENAME=$(basename "$FILE")
    curl -H "Authorization: token $GITHUB_ACCESS_TOKEN" \
         -H "Content-Type: application/octet-stream" \
         -T "$FILE" \
         "$UPLOAD_URL?name=$FILENAME"
done

echo ""
echo "------Recovery uploaded------"
echo ""
