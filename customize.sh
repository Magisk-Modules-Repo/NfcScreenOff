#!/system/bin/sh

REPLACE="
/system/app/NfcNci
"
APK_PATH="/system/app/NfcNci/NfcNcii.apk"

[ $API -eq 28 ] || abort "! Your version of Android is not compatible."
[ -f $APK_PATH ] || abort "! Could not find $APK_PATH, your phone may not be compatible with NFC technology."

ui_print "- Backing up original NfcNci.apk"
cp "$APK_PATH" "$MODPATH/NfcNci_bak.apk"
