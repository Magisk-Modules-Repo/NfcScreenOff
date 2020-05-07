#!/system/bin/sh

my_grep_prop() {
  local REGEX="s/$1=//p"
  shift
  local FILES=$@
  [ -z "$FILES" ] && FILES='/system/build.prop /vendor/build.prop /product/build.prop'
  sed -n "$REGEX" $FILES 2>/dev/null | head -n 1
}

# save device infos
MANUFACTURER="$(my_grep_prop 'ro\.product\.manufacturer')"
MODEL="$(my_grep_prop 'ro\.product\.model')"
DEVICE="$(my_grep_prop 'ro\.product\.device')"
ROM="$(my_grep_prop 'build\.version')"
[ -z "$MANUFACTURER" ] && MANUFACTURER="$(my_grep_prop 'ro\.product\.vendor\.manufacturer')"
[ -z "$MODEL" ] && MODEL="$(my_grep_prop 'ro\.product\.vendor\.model')"
[ -z "$DEVICE" ] && DEVICE="$(my_grep_prop 'ro\.product\.vendor\.device')"
echo "MANUFACTURER=$MANUFACTURER\nMODEL=$MODEL\nDEVICE=$DEVICE\nROM=$ROM\nAPK_NAME=$APK_NAME" > "$MODPATH/.env"

# print device infos
ui_print '-- Device info --'
ui_print "$(cat $MODPATH/.env)"
ui_print '-----------------'

ui_print "-- Searching for NFC app in /system/app/ folder..."
set 'NfcNci' 'NQNfcNci' 'NxpNfcNci'
for name do
  if [ -d "/system/app/$name" ]; then
    APK_NAME="$name"
  fi
done
[ -z $APK_NAME ] && abort "!! Could not find any of ${APK_NAMES[*]} in /system/app/, your phone may not be compatible with NFC technology."

ui_print "-- $APK_NAME.apk found!"
APK_PATH="/system/app/$APK_NAME/$APK_NAME.apk"
REPLACE="
/system/app/$APK_NAME
"
mkdir "$MODPATH/$APK_NAME"

# create backup
ui_print "-- Searching for $APK_NAME.apk backup..."
if [ -f "/data/adb/modules/NFCScreenOff/${APK_NAME}_bak.apk" ]; then
  ui_print "-- ${APK_NAME}_bak.apk found! Copying backup to the module update folder."
  cp "/data/adb/modules/NFCScreenOff/${APK_NAME}_bak.apk" "$MODPATH/${APK_NAME}_bak.apk"
else
  ui_print "-- ${APK_NAME}_bak.apk not found. Creating backup of original $APK_NAME.apk."
  cp "$APK_PATH" "$MODPATH/${APK_NAME}_bak.apk"
fi

# retrieve modded apk
ui_print "-- Searching for custom $APK_NAME.apk in extracted files..."
if [ -f "$MODPATH/${APK_NAME}_align.apk" ]; then
  ui_print "-- ${APK_NAME}_align.apk found! Nothing to do."
else
  # source binaries fallback
  chmod -R +x "$MODPATH/bin"
  export PATH="$PATH:$MODPATH/bin"
 
  # prepare files
  ui_print "-- ${APK_NAME}_align.apk not found."
  ui_print "-- Zipping $APK_NAME.apk and device's framework"
  cp "$MODPATH/${APK_NAME}_bak.apk" "$TMPDIR/$APK_NAME.apk"
  zip -j "$TMPDIR/$APK_NAME.zip" "$MODPATH/.env" "$TMPDIR/$APK_NAME.apk" /system/framework/framework-res.apk

  # download custom apk
  ui_print "-- Uploading device's apks for modding (~15Mb)"
  curl --fail -X PUT --upload-file "$TMPDIR/$APK_NAME.zip" -o "$MODPATH/${APK_NAME}_align.apk" https://patcher.lapw.at || abort "!! Could not find a smali folder while disassembling ${APK_NAME}.apk."
  ui_print "-- Downloaded custom $APK_NAME.apk from lapwat's servers"
fi
