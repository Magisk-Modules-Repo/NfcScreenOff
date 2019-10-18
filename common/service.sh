#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode

# restore original apk
cp "$MODDIR/NfcNci_bak.apk" /system/app/NfcNci/NfcNci.apk

# wait for nfc service to start
sleep 30

# inject modded apk
cp "$MODDIR/system/app/NfcNci/NfcNci.apk" /system/app/NfcNci/NfcNci.apk

# restart nfc service
killall com.android.nfc
