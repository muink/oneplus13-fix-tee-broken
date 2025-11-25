#!/system/bin/sh

PRJNAME=$(getprop ro.boot.prjname)

if echo "$PRJNAME" | grep -qv "^2[34]821$"; then
  ui_print "! This module is for OnePlus 13 / 13T / 13S version only."
  ui_print "! DO NOT install this module on other devices!"
  abort "> Aborting..."
fi
