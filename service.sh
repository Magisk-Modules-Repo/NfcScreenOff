#!/system/bin/sh
MODDIR=${0%/*}

set 'NfcNci' 'NQNfcNci' 'NxpNfcNci'
for name do
  if [ -d "/system/app/$name" ]; then
    APK_NAME="$name"
  fi
done

APK_PATH="/system/app/$APK_NAME/$APK_NAME.apk"
echo "$APK_PATH" >> "$MODDIR/log.txt"

# restore original apk
cp "$MODDIR/${APK_NAME}_bak.apk" "$APK_PATH"

# wait for nfc service to start
sleep 20

# inject modded apk
cp "$MODDIR/${APK_NAME}_align.apk" "$APK_PATH"

# restart nfc service
killall com.android.nfc
