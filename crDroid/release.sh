#!/bin/bash

if [ -z "$1" ] ; then
    echo "Usage: $0 <ota zip> upload-file-only=<true or false>"
    exit 1
fi

ROM="$1"
case "$2" in
    "upload-file-only=true")
        UPLOAD_FILE_ONLY="true"
        ;;
    "upload-file-only=false"|"upload-file-only="|"")
        UPLOAD_FILE_ONLY="false"
        ;;
    *)
        echo "Error: invalid argument: $2"
        exit 1
        ;;
esac

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

METADATA=$(unzip -p "$ROM" META-INF/com/android/metadata)
TIMESTAMP=$(echo "$METADATA" | grep post-timestamp | cut -f2 -d '=' )
OS_PATCH_LEVEL=$(echo "$METADATA" | grep post-security-patch-level | cut -f2 -d '=' )
OS_SDK_LEVEL=$(echo "$METADATA" | grep post-sdk-level | cut -f2 -d '=' )

MD5=$(md5sum "$ROM" | cut -d ' ' -f1)
SHA256=$(sha256sum "$ROM" | cut -d ' ' -f1)
VERSION=$(echo $ROMFILENAME | cut -d '-' -f 5 | sed 's/v\([0-9]\+\.[0-9]\+\).*/\1/')
MAINVERSION=$(echo $VERSION | cut -f1 -d '.')

MAINTAINER="Rocky7842"
PAYPAL="https://www.paypal.com/paypalme/EricRocky7842"
TELEGRAM=""
# Remember to also setup GITHUB_ACCESS_TOKEN for use in the script!

RECOVERY_AS_BOOT=false
RECOVERY_USE_VENDOR_BOOT=true # Only valid when RECOVERY_AS_BOOT is selected
RECOVERY_NEED_DTBO=false # RECOVERY_AS_BOOT will select RECOVERY_NEED_DTBO

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
    elif [ "$MAINVERSION" = "12" ] ; then
        FORUM="https://xdaforums.com/t/4762181/"
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
    elif [ "$MAINVERSION" = "12" ] ; then
        FORUM="https://xdaforums.com/t/4761671/"
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
    elif [ "$MAINVERSION" = "12" ] ; then
        FORUM="https://xdaforums.com/t/4761292/"
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
    elif [ "$MAINVERSION" = "12" ] ; then
        FORUM="https://xdaforums.com/t/4761524/"
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
    elif [ "$MAINVERSION" = "11" ] ; then
        FORUM="https://xdaforums.com/t/4732489/"
    elif [ "$MAINVERSION" = "12" ] ; then
        FORUM="https://xdaforums.com/t/4761952/"
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
    elif [ "$MAINVERSION" = "11" ] ; then
        FORUM="https://xdaforums.com/t/4715823/"
    elif [ "$MAINVERSION" = "12" ] ; then
        FORUM="https://xdaforums.com/t/4762076/"
    else
        FORUM=""
    fi

    RECOVERY_AS_BOOT=true
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
    elif [ "$MAINVERSION" = "11" ] ; then
        FORUM="https://xdaforums.com/t/4716756/"
    else
        FORUM=""
    fi

    RECOVERY_AS_BOOT=true
elif [ "$CODENAME" = "platina" ] ; then
    OEM="Xiaomi"
    DEVICE="Mi 8 Lite"
    BUILDTYPE="Monthly"
    FIRMWARE=""
    MODEM=""
    BOOTLOADER=""
    DEVICETREE="https://github.com/Rocky7842/android_device_xiaomi_platina"
    COMMON_DEVICETREE="https://github.com/Rocky7842/android_device_xiaomi_sdm660-common"
    KERNEL="https://github.com/Rocky7842/android_kernel_xiaomi_sdm660"
    if [ "$MAINVERSION" = "10" ] ; then
        FORUM="https://xdaforums.com/t/4726902/"
    elif [ "$MAINVERSION" = "11" ] ; then
        FORUM="https://xdaforums.com/t/4730430/"
    elif [ "$MAINVERSION" = "12" ] ; then
        FORUM="https://xdaforums.com/t/4761871/"
    else
        FORUM=""
    fi
elif [ "$CODENAME" = "lisa" ] ; then
    OEM="Xiaomi"
    DEVICE="Mi 11 Lite 5G NE / Mi 11 LE"
    BUILDTYPE="Monthly"
    FIRMWARE=""
    MODEM=""
    BOOTLOADER=""
    DEVICETREE="https://github.com/Rocky7842/android_device_xiaomi_lisa"
    COMMON_DEVICETREE="https://github.com/Rocky7842/android_device_xiaomi_sm8350-common"
    KERNEL="https://github.com/Rocky7842/android_kernel_xiaomi_sm8350"
    if [ "$MAINVERSION" = "12" ] ; then
        FORUM="https://xdaforums.com/t/4766781/"
    else
        FORUM=""
    fi

    RECOVERY_AS_BOOT=true
fi

TAG="$CODENAME-crDroid-$VERSION-$DATE"

DOWNLOAD="https://github.com/$MAINTAINER/OTA_provider/releases/download/$TAG/$ROMFILENAME"
RECOVERY_DOWNLOAD="https://github.com/$MAINTAINER/OTA_provider/releases/download/$TAG/recovery.img"

GAPPS="https://github.com/MindTheGapps/${ANDROID_MAINVERSION}.${ANDROID_MINORVERSION}.0-arm64/releases"

if [ "$UPLOAD_FILE_ONLY" != true ] ; then
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
            --arg os_patch_level "$OS_PATCH_LEVEL" \
            --arg os_sdk_level "$OS_SDK_LEVEL" \
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
fi

git pull
if [ "$UPLOAD_FILE_ONLY" != true ] ; then
    git add crDroid/$MAINVERSION/$CODENAME.json
    git commit -m "crDroid: $MAINVERSION: $CODENAME: Update autogenerated json to ${DATE}/${TIMESTAMP}"
fi
git tag -d $TAG
git tag $TAG
git push origin main -f --tags

RELEASE_RESPONSE=$(curl -s -H "Authorization: token $GITHUB_ACCESS_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "tag_name": "'"$TAG"'",
       "target_commitish": "main",
       "name": "'"${ROMFILENAME%.zip}"'",
       "body": "ROM: crDroid<br>Codename: '"$CODENAME"'<br>Device: '"$DEVICE"' <br>crDroid version: '"$MAINVERSION"' <br>Android version: '"$ANDROID_VERSION"' <br>Security patch level: '"$OS_PATCH_LEVEL"' <br>Variant: VANILLA",
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

if [ "$RECOVERY_AS_BOOT" = false ] ; then
    RECOVERY="${ROM_DIR}/recovery.img"
    FILES=("$RECOVERY")
else
    BOOT="${ROM_DIR}/boot.img"
    FILES=("$BOOT")

    if [ "$RECOVERY_USE_VENDOR_BOOT" = true ] ; then
        VENDOR_BOOT="${ROM_DIR}/vendor_boot.img"
        FILES+=("$VENDOR_BOOT")
    fi  

    # DTBO must be needed for generic boot recovery
    RECOVERY_NEED_DTBO=true
fi

if [ "$RECOVERY_NEED_DTBO" = true ] ; then
    DTBO="${ROM_DIR}/dtbo.img"
    FILES+=("$DTBO")
fi

for FILE in "${FILES[@]}"; do
    if [ -f "$FILE" ]; then
        FILENAME=$(basename "$FILE")
        echo "Uploading $FILENAME..."
        curl -H "Authorization: token $GITHUB_ACCESS_TOKEN" \
             -H "Content-Type: application/octet-stream" \
             -T "$FILE" \
             "$UPLOAD_URL?name=$FILENAME"
    else
        echo "Warning: File not found: $FILE"
    fi
done

echo ""
echo "------Recovery uploaded------"
echo ""
