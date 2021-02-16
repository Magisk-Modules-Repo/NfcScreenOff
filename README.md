# NFCScreenOff

Read NFC tags when screen is off.

_Useful integrations: [NFC Card Emulator Pro](https://play.google.com/store/apps/details?id=com.yuanwofei.cardemulator.pro) - [Tasker](https://play.google.com/store/apps/details?id=net.dinglisch.android.taskerm)_

# How does it work?

The NFC app is patched during installation into a `modded` version. This `modded` version is injected at boot time by [service.sh](service.sh) so that the phone thinks the screen is always on and unlocked. This patch only applies to NFC Service so it does not impact any other functionality of the phone that involves screen state detection.

The `modded` app was generated using [this method](https://github.com/lapwat/NfcScreenOffPie).

# Help section

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
1. Reboot

If it does not solve your problem, you can create an issue.

**TAP TO PAY DOES NOT WORK WHEN SCREEN IS OFF**

This is normal, you need to wake up the device to pay in stores.

_Tap to pay functionality is now in BETA so it may work for some devices._

**MY NFC IS NOT DETECTED ANYMORE**

If you did not unlock your device since last boot, unlock it and wait 30 seconds for the module to be loaded.

After that time, if NFC does not start automatically or manually, it means that the patch does not work for your device. You can uninstall the module and create an issue.
