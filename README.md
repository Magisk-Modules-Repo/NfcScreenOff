# NFCScreenOff8+

This module let you enable NFC Pooling while phone is locked and screen is off for Android 8 and above.

> Please make a backup of your original NfcNci.apk with `adb pull /system/app/NfcNci/NfcNci.apk` before installing this module.

I have patched the original `NfcNci.apk` (com/android/nfc/ScreenStateHelper.smali) so that the phone thinks the screen is always on and unlocked. This patch only applies to NFC Service so it does not impact any other functionalities of the phone.

I only succeeded to make it work if the `modded` APK is injected while the phone is booted with the `original` APK. That is why I inject the `modded` APK in `[common/service.sh]`.

The modded APK was generated using the method described [here](https://github.com/lapwat/NfcScreenOffPie).

TODO
- [] Make a backup of original NfcNci.apk file so it can be restored when the the user uninstalls the module
- [] Test on other phones (will a different framework-res.apk impact the generated APK?)
- [] Decompile and recompile the host NfcNci.apk file rather than copying my modded APK