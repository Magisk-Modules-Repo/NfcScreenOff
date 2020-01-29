#!/system/bin/sh

APK_NAME_AOSP="NfcNci"
APK_NAME_ONEPLUS="NxpNfcNci"

[ $API -ge 28 ] || abort "! Your Android version is not compatible."

if [ -d "/system/app/$APK_NAME_AOSP" ]; then
  ui_print "- Found /system/app/$APK_NAME_AOSP"
  APK_NAME="$APK_NAME_AOSP"
elif [ -d "/system/app/$APK_NAME_ONEPLUS" ]; then
  ui_print "- Found /system/app/$APK_NAME_ONEPLUS"
  APK_NAME="$APK_NAME_ONEPLUS"
else
  abort "! Could not find $APK_NAME_AOSP nor $APK_NAME_ONEPLUS, your phone may not be compatible with NFC technology."
fi

APK_PATH="/system/app/$APK_NAME/$APK_NAME.apk"
REPLACE="
/system/app/$APK_NAME
"

ui_print "- Backing up original $APK_NAME.apk"
cp "$APK_PATH" "$MODPATH/${APK_NAME}_bak.apk"

ui_print "- Selecting modded ${APK_NAME}.apk based on your API level ($API)."
cp "$MODPATH/${APK_NAME}${API}_align.apk" "$MODPATH/${APK_NAME}_align.apk"
