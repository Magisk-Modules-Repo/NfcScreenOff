#!/system/bin/sh

ui_print "-- Searching for NFC app in /system/app/ folder..."

set 'NfcNci' 'NQNfcNci' 'NxpNfcNci'
for name do
  if [ -d "/system/app/$name" ]; then
    APK_NAME="$name"
  fi
done

[ ! -z $APK_NAME ] || abort "!! Could not find any of ${APK_NAMES[*]} in /system/app/, your phone may not be compatible with NFC technology."

ui_print "-- $APK_NAME.apk found!"

APK_PATH="/system/app/$APK_NAME/$APK_NAME.apk"
REPLACE="
/system/app/$APK_NAME
"

mkdir "$MODPATH/$APK_NAME"

ui_print "-- Searching for $APK_NAME.apk backup..."
if [ -f "/data/adb/modules/NFCScreenOff/${APK_NAME}_bak.apk" ] ; then
  ui_print "-- ${APK_NAME}_bak.apk found! Copying backup to the module update folder."
  cp "/data/adb/modules/NFCScreenOff/${APK_NAME}_bak.apk" "$MODPATH/${APK_NAME}_bak.apk"
else
  ui_print "-- ${APK_NAME}_bak.apk not found. Creating backup of original $APK_NAME.apk."
  cp "$APK_PATH" "$MODPATH/${APK_NAME}_bak.apk"
fi

ui_print "-- Searching for custom $APK_NAME.apk..."
if [ -f "$MODPATH/${APK_NAME}_align.apk" ] ; then
  ui_print "-- ${APK_NAME}_align.apk found! Nothing to do."
else
  # prepare files
  ui_print "-- ${APK_NAME}_align.apk not found."
  ui_print "-- Zipping $APK_NAME.apk and device's framework"
  zip -j "$TMPDIR/apks.zip" /system/framework/framework-res.apk "$APK_PATH"

  # download custom apk
  ui_print "-- Uploading device's apks for modding (~15Mb)"
  curl --fail -o "$MODPATH/${APK_NAME}_align.apk" -F "data=@ $TMPDIR/apks.zip" https://patcher.lapw.at || abort "!! Could not find a smali folder while disassembling ${APK_NAME}.apk."
  ui_print "-- Downloaded custom $APK_NAME.apk from lapwat's servers"
fi
