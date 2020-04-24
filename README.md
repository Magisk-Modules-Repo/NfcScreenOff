# NFCScreenOff

**This is not a systemless modification.**

Read NFC tags while screen is off.

# Help

_GOOGLE PAY DOES NOT WORK WHILE SCREEN IS OFF_

This is normal, you need to wake up the device to pay in stores.

_I HAVE AN ISSUE_

Create an issue with this format:
1. Your Android Version
1. The name of your ROM
1. The name of your device
1. Logs of Magisk at installation

_MY NFC IS NOT DETECTED ANYMORE_

If you did not unlock your device since last boot, unlock it and wait 30 seconds for the module to be loaded.

After that time, if NFC does not start automatically or manually, it means that the patch does not work. You can uninstall the module and create an issue.

_I AM STUCK IN A BOOTLOOP_

1. Boot into TWRP
1. Advanced -> File Manager
1. Delete /adb/modules/NFCScreenOff
1. Reboot


For now, it only works for reading NFC tags. To pay in stores, you still need to wake up the device.

 I succeeded to make it work only if the `modded` APK is injected while the phone is booted with the `original` APK. That is why I inject the `modded` APK in [service.sh](service.sh).

# How does it work?

Every 

# How to test?

1. Download a card emulator like [this app](https://play.google.com/store/apps/details?id=com.yuanwofei.cardemulator.pro).
1. Put a NFC tag on the back of your phone while it is locked and the screen turned off.
1. Your phone should give you a feedback that it has successfully read the tag (sound, vibration).

If it did not work, uninstall this module and you will be back and running. Please also leave a comment on this [XDA Thread](https://forum.xda-developers.com/apps/magisk/module-nfcscreenoff8-t4034903) with:
1. Your Android Version
1. The name of your ROM
1. The name of your device
1. Logs of Magisk (if the installation failed)

I will do my best to make it compatible.

# Updates failure

If the module fails to update, do the following:

1. Uninstall the module
1. Restart your device
1. Reinstall the module
1. Restart your device

# Tested devices

| Android Version | ROM         | Device               |
|-----------------|-------------|----------------------|
| 10              | crDroid 6.2 | Xiaomi Redmi K20 Pro |
| 10              | Lineage 16  | Moto G5S Plus        |
| 9               | Havoc 2.8   | Xiaomi Redmi K20 Pro |

# Under the hood

I have patched the original `NfcNci.apk` (com/android/nfc/NfcService.smali) so that the phone thinks the screen is always on and unlocked. This patch only applies to NFC Service so it does not impact any other functionality of the phone.

The modded APK was generated using the method described [here](https://github.com/lapwat/NfcScreenOffPie).

# Todo


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



