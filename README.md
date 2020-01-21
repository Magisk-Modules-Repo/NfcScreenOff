# NFCScreenOff

Enable NFC pooling while **phone is locked and screen is off** for Android 9 and above.

> If you restart your phone, wait 30 seconds after unlocking it to let NFC service time to reload.

For now, it only works for reading NFC tags, not for payments in stores.

**This is not a systemless modification.** I succeeded to make it work only if the `modded` APK is injected while the phone is booted with the `original` APK. That is why I inject the `modded` APK in [service.sh](service.sh).

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
- [ ] Make it work for host card emulator to pay in stores
