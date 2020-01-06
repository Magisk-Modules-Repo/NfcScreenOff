# NFCScreenOff8+

This module lets you enable NFC Pooling while phone is locked and screen is off for Android 8 and above.

> Wait 30 seconds after restarting+unlocking your phone. It will let NFC service time to reload.

For now, it only works for reading NFC tags, not for payments in stores.

I have patched the original `NfcNci.apk` (com/android/nfc/ScreenStateHelper.smali) so that the phone thinks the screen is always on and unlocked. This patch only applies to NFC Service so it does not impact any other functionality of the phone.

I succeeded to make it work only if the `modded` APK is injected while the phone is booted with the `original` APK. That is why I inject the `modded` APK in [common/service.sh](common/service.sh).

The modded APK was generated using the method described [here](https://github.com/lapwat/NfcScreenOffPie).

TODO
- [x] Make a backup of original NfcNci.apk file so it can be restored when the phone restarts
- [x] Test on other phones (will a different framework-res.apk impact the generated APK?)
  - [x] Xiaomi Redmi K20 Pro (Havoc 2.8)
  - [x] Moto G5S Plus Lineage 16 (Android Pie)
- [ ] Make it work for host card emulator to pay in stores
- [ ] Decompile and recompile the host NfcNci.apk file rather than copying my custom modded APK
