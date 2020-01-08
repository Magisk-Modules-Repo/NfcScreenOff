#!/system/bin/sh

REPLACE="
/system/app/NfcNci
"

ui_print "- Backing up original NfcNci.apk"
cp /system/app/NfcNci/NfcNci.apk $MODPATH/NfcNci_bak.apk
