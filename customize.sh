#!/system/bin/sh

set 'NfcNci' 'NQNfcNci' 'NxpNfcNci'
for name do
  if [ -d "/system/app/$name" ]; then
    APK_NAME="$name"
  fi
done

[ ! -z $APK_NAME ] || abort "! Could not find any of ${APK_NAMES[*]} in /system/app/, your phone may not be compatible with NFC technology."

APK_PATH="/system/app/$APK_NAME/$APK_NAME.apk"
REPLACE="
/system/app/$APK_NAME
"

ui_print "- Backing up original $APK_NAME.apk"
cp "$APK_PATH" "$MODPATH/${APK_NAME}_bak.apk"

ui_print "- Zipping $APK_NAME.apk"
zip -j "$TMPDIR/apks.zip" /system/framework/framework-res.apk "$APK_PATH"

ui_print "- Downloading custom apk from lapwat's servers"
#curl --fail -o "$MODPATH/${APK_NAME}_align.apk" -F "data=@ $TMPDIR/apks.zip" https://patcher.lapw.at || abort "! Could not find a smali folder while disassembling ${APK_NAME}.apk."
