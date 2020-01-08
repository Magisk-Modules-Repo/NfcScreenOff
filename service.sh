#!/system/bin/sh
MODDIR=${0%/*}

# restore original apk
cp "$MODDIR/NfcNci_bak.apk" /system/app/NfcNci/NfcNci.apk

# wait for nfc service to start
sleep 20

# inject modded apk
cp "$MODDIR/NfcNci_align.apk" /system/app/NfcNci/NfcNci.apk

# restart nfc service
killall com.android.nfc
