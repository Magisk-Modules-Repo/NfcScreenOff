#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode
cp /system/app/NfcNci/NfcNci_bak.apk /system/app/NfcNci/NfcNci.apk
sleep 30
cp /system/app/NfcNci/NfcNci_align.apk /system/app/NfcNci/NfcNci.apk
killall com.android.nfc