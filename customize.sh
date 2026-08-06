#!/system/bin/sh
SKIPUNZIP=1

PRJNAME=$(getprop ro.boot.prjname)

if echo "$PRJNAME" | grep -qv "^2[34]821$"; then
  ui_print "! This module is for OnePlus 13 / 13T / 13S version only."
  ui_print "! DO NOT install this module on other devices!"
  abort "> Aborting..."
fi

ui_print "[+] Extracting module files"
unzip -o "$ZIPFILE" -x 'bin/*' -x 'META-INF/*' -d $MODPATH >&2
set_perm_recursive $MODPATH 0 0 0755 0644

ui_print "[+] Install provision_device_ids command"
unzip -o "$ZIPFILE" 'bin/*' -d $TMPDIR >&2
file_path="$TMPDIR/bin/provision_device_ids-aebb613"
(echo "$(cat "$file_path.sha256")  $file_path" | sha256sum -c -s -) || abort "[-] Failed to verify provision_device_ids binary."
mkdir -p $MODPATH/system/bin 2>/dev/null
cp -f $file_path $MODPATH/system/bin/provision_device_ids
set_perm $MODPATH/system/bin/provision_device_ids 0 0 755

ui_print "[+] Installation completed!"
ui_print "[+] Please execute the \"Action\" after rebooting."
