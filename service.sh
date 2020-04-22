#!/system/bin/sh
MODDIR=${0%/*}

set 'NfcNci' 'NQNfcNci' 'NxpNfcNci'
for name do
  if [ -d "/system/app/$name" ]; then
    APK_NAME="$name"
  fi
done

APK_PATH="/system/app/$APK_NAME/$APK_NAME.apk"

# restore original apk
cp "$MODDIR/${APK_NAME}_bak.apk" "$MODDIR/$APK_NAME/$APK_NAME.apk"
mount --bind "$MODDIR/$APK_NAME" "/system/app/$APK_NAME"

# wait for nfc service to start
sleep 20

# inject modded apk
cp "$MODDIR/${APK_NAME}_align.apk" "$MODDIR/$APK_NAME/$APK_NAME.apk"
mount --bind "$MODDIR/$APK_NAME" "/system/app/$APK_NAME"

# restart nfc service
killall com.android.nfc
