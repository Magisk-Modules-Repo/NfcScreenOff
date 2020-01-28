#!/system/bin/sh
MODDIR=${0%/*}

APK_NAME_AOSP="NfcNci"
APK_NAME_ONEPLUS="NxpNfcNci"

if [ -f "/system/app/$APK_NAME_AOSP/$APK_NAME_AOSP.apk" ]; then
  APK_NAME="$APK_NAME_AOSP"
else
  APK_NAME="$APK_NAME_ONEPLUS"
fi

# restore original apk
cp "$MODDIR/${APK_NAME}_bak.apk" "/system/app/$APK_NAME/$APK_NAME.apk"

# wait for nfc service to start
sleep 20

# inject modded apk
cp "$MODDIR/${APK_NAME}_align.apk" "/system/app/$APK_NAME/$APK_NAME.apk"

# restart nfc service
killall com.android.nfc
