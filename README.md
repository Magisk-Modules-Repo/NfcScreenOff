# NFCScreenOff

**This is not a systemless modification.**

Read NFC tags when screen is off.

_Useful integrations_
[NFC Card Emulator Pro](https://play.google.com/store/apps/details?id=com.yuanwofei.cardemulator.pro)
[Tasker](https://play.google.com/store/apps/details?id=net.dinglisch.android.taskerm)

# Help section

**GOOGLE PAY DOES NOT WORK WHEN SCREEN IS OFF**

This is normal, you need to wake up the device to pay in stores.

**MY NFC IS NOT DETECTED ANYMORE**

If you did not unlock your device since last boot, unlock it and wait 30 seconds for the module to be loaded.

After that time, if NFC does not start automatically or manually, it means that the patch does not work. You can uninstall the module and create an issue.

**I AM STUCK IN A BOOTLOOP**

Remove the module manually.

1. Boot into TWRP
1. Advanced -> File Manager
1. Delete /adb/modules/NFCScreenOff
1. Reboot

**THE MODULE IS NOT WORKING SINCE LAST UPDATE**

Perform a clean reinstallation.

1. Uninstall the module
1. Reboot
1. Install the module
1. Restart your device

If it does not solve your problem, you can create an issue.

# How does it work?

I succeeded to make it work only if the `modded` APK is injected while the phone is booted with the `original` APK. That is why I inject the `modded` APK in [service.sh](service.sh).

I have patched the original `NfcNci.apk` (com/android/nfc/NfcService.smali) so that the phone thinks the screen is always on and unlocked. This patch only applies to NFC Service so it does not impact any other functionality of the phone.

The modded APK was generated using the method described [here](https://github.com/lapwat/NfcScreenOffPie).


I will do my best to make it compatible.

# Working devices

| Android Version | ROM         | Device               |
|-----------------|-------------|----------------------|
| 10              | crDroid 6.2 | Xiaomi Redmi K20 Pro |
| 10              | Lineage 16  | Moto G5S Plus        |
| 9               | Havoc 2.8   | Xiaomi Redmi K20 Pro |

Leave a comment with your working device on the [XDA thread](https://forum.xda-developers.com/apps/magisk/module-nfcscreenoff8-t4034903).

# Useful

```sh
# disassemble with baksmali
java -jar baksmali-2.4.0.jar x -c arm64/boot.oat -d arm64/ NfcNci.odex -o NfcNci

# mod
sed 's/SCREEN_ON/SCREEN_ONA/' -i  "NfcNci/com/android/nfc/NfcService.smali"
sed 's/SCREEN_OFF/SCREEN_OFFA/' -i "NfcNci/com/android/nfc/NfcService.smali"
sed 's/USER_PRESENT/USER_PRESENTA/' -i "NfcNci/com/android/nfc/NfcService.smali"
sed 's/USER_SWITCHED/USER_SWITCHEDA/' -i "NfcNci/com/android/nfc/NfcService.smali"

# assemble with smali
java -jar smali-2.4.0.jar a -o classes.dex NfcNci/

# backup original
cp NfcNci.apk NfcNci_mod.apk
zip -rv NfcNci_mod.apk classes.dex
```
