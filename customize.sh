#!/system/bin/sh

REPLACE="
/system/app/NfcNci
"
APK_PATH="/system/app/NfcNci/NfcNci.apk"

[ $API -ge 28 ] || abort "! Your Android version is not compatible."
[ -f $APK_PATH ] || abort "! Could not find $APK_PATH, your phone may not be compatible with NFC technology."

ui_print "- Backing up original NfcNci.apk"
cp "$APK_PATH" "$MODPATH/NfcNci_bak.apk"

ui_print "- Selecting modded NfcNci.apk based on your API level ($API)."
mv "$MODPATH/NfcNci${API}_align.apk" "$MODPATH/NfcNci_align.apk"
