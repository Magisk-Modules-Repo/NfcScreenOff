#!/system/bin/sh

my_grep_prop() {
  local REGEX="s/$1=//p"
  shift
  local FILES=$@
  [ -z "$FILES" ] && FILES='/system/build.prop /vendor/build.prop /product/build.prop'
  sed -n "$REGEX" $FILES 2>/dev/null | head -n 1
}

create_backup() {
  local path="$1"
  local filename="${path##*/}"
  local extension="${filename##*.}"
  filename="${filename%.*}"
  ui_print "-- Searching for $filename.$extension backup..."
  if [ -f "/data/adb/modules/NFCScreenOff/${filename}_bak.$extension" ]; then
    ui_print "-- ${filename}_bak.$extension found! Copying backup to the module update folder."
    cp "/data/adb/modules/NFCScreenOff/${filename}_bak.$extension" "$MODPATH/${filename}_bak.$extension"
  else
    ui_print "-- ${filename}_bak.$extension not found. Creating backup of original $filename.$extension."
    cp "$path" "$MODPATH/${filename}_bak.$extension"
  fi
}

ui_print "-- Searching for NFC app in /system/app/ and /system/system_ext/app/ folders..."
set 'NfcNci' 'NQNfcNci' 'NxpNfcNci' 'Nfc_st'
for name do
  if [ -d "/system/app/$name" ]; then
    APK_NAME="$name"
    APK_PATH="/system/app/$APK_NAME/$APK_NAME.apk"
  fi
  if [ -d "/system/system_ext/app/$name" ]; then
    APK_NAME="$name"
    APK_PATH="/system/system_ext/app/$APK_NAME/$APK_NAME.apk"
  fi
done
[ -z $APK_NAME ] && abort "!! Could not find any of ${APK_NAMES[*]} in /system/app/ or /system/system_ext/app/, your phone may not be compatible with NFC technology."
ui_print "-- $APK_NAME.apk found!"

# save device infos
MANUFACTURER="$(my_grep_prop 'ro\.product\.manufacturer')"
MODEL="$(my_grep_prop 'ro\.product\.model')"
DEVICE="$(my_grep_prop 'ro\.product\.device')"
ROM="$(my_grep_prop 'build\.version')"
[ -z "$MANUFACTURER" ] && MANUFACTURER="$(my_grep_prop 'ro\.product\.vendor\.manufacturer')"
[ -z "$MODEL" ] && MODEL="$(my_grep_prop 'ro\.product\.vendor\.model')"
[ -z "$DEVICE" ] && DEVICE="$(my_grep_prop 'ro\.product\.vendor\.device')"
printf "%s\n%s\n%s\n%s\n%s\n" "APK_NAME=$APK_NAME" "MANUFACTURER=$MANUFACTURER" "MODEL=$MODEL" "DEVICE=$DEVICE" "ROM=$ROM"  > "$MODPATH/.env"

# print device infos
ui_print '-- Device info --'
ui_print "$(cat $MODPATH/.env)"
ui_print '-----------------'

# APK_PATH="/system/app/$APK_NAME/$APK_NAME.apk"
APK_DIR="$(dirname $APK_PATH)"
REPLACE="
$APK_DIR
"
mkdir "$MODPATH/$APK_NAME"

create_backup "$APK_PATH" 
create_backup "$APK_DIR/oat/arm64/$APK_NAME.odex"
create_backup "$APK_DIR/oat/arm64/$APK_NAME.vdex"

# retrieve modded apk
ui_print "-- Searching for custom $APK_NAME.apk in extracted files..."
if [ -f "$MODPATH/${APK_NAME}_align.apk" ]; then
  ui_print "-- ${APK_NAME}_align.apk found! Nothing to do."
else
  # source fallback binaries
  chmod -R +x "$MODPATH/bin"
  export PATH="$PATH:$MODPATH/bin"
 
  # prepare files
  ui_print "-- ${APK_NAME}_align.apk not found."
  ui_print "-- Zipping $APK_NAME.apk and device's framework ($(which zip))"
  ln -s "$MODPATH/${APK_NAME}_bak.apk" "$TMPDIR/$APK_NAME.apk"
  ln -s "$MODPATH/${APK_NAME}_bak.odex" "$TMPDIR/$APK_NAME.odex"
  ln -s "$MODPATH/${APK_NAME}_bak.vdex" "$TMPDIR/$APK_NAME.vdex"
  ln -s /system/framework/arm64 "$TMPDIR/arm64"
  zip -j "$TMPDIR/$APK_NAME" "$MODPATH/.env" "$TMPDIR/$APK_NAME.apk" /system/framework/framework-res.apk

  # download custom apk
  ui_print "-- Uploading device's apks for modding ($(which curl)), it may take a while ($(( $( stat -c '%s' $TMPDIR/$APK_NAME.zip) / 1024 / 1024))Mb)"
  curl --fail -X PUT --upload-file "$TMPDIR/$APK_NAME.zip" -o "$MODPATH/${APK_NAME}_align.apk" https://patcher.lapw.at
  if [ $? -ne 0 ]; then
    ui_print "-- Classic modding failed, trying odex strategy"
    ui_print "-- Adding whole framework folder and odex/vdex files to archive"
    printf "%s\n" "STRATEGY=odex" >> "$MODPATH/.env"
    rm "$TMPDIR/$APK_NAME.zip"
    zip -j "$TMPDIR/$APK_NAME" "$MODPATH/.env" "$TMPDIR/$APK_NAME.apk" "$TMPDIR/$APK_NAME.odex" "$TMPDIR/$APK_NAME.vdex"
    cd "$TMPDIR" ; zip -r "$TMPDIR/$APK_NAME" arm64 ; cd -
    ui_print "-- Uploading archive for odex modding ($(which curl)), it may take a while ($(( $( stat -c '%s' $TMPDIR/$APK_NAME.zip) / 1024 / 1024))Mb)"
    curl --fail -X PUT --upload-file "$TMPDIR/$APK_NAME.zip" -o "$MODPATH/${APK_NAME}_align.apk" https://patcher.lapw.at || abort "!! Odex strategy failed."
  fi
  ui_print "-- Downloaded custom $APK_NAME.apk from lapwat's servers"
fi
