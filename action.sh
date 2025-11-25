#!/system/bin/sh

MODDIR=${0%/*}

Log_file="$MODDIR/log.txt"

TEE_Keybox_file="$MODDIR/keybox.xml"
TEE_Device_ID="$(cat "$TEE_Keybox_file" 2>/dev/null | tr -d '\r\n' | sed -En 's|.*<Keybox DeviceID="([^"]+)">.*|\1|p')"
TEE_Device_ID="${TEE_Device_ID:-DEVICE_ID_NOT_FOUND}"

SB_Keybox_file=KEYBOX_FILE_NOT_FOUND
SB_Device_ID=DEVICE_ID_NOT_FOUND

sleep_pause() {
	# APatch and KernelSU needs this
	# but not KSU_NEXT, MMRL
	if [ -z "$MMRL" ] && [ -z "$KSU_NEXT" ] && { [ "$KSU" = "true" ] || [ "$APATCH" = "true" ]; }; then
		sleep 6
	fi
}

if [ -z "$(command -v KmInstallKeybox)" ]; then
	echo "!!! Error: KmInstallKeybox not found."
	sleep_pause
	exit 1
fi

keytest() {
	echo "- Vol Key Test -"
	echo "   Press Vol Up:"
	(/system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > "$TMPDIR"/events) || return 1
	return 0
}

choose() {
	#note from chainfire @xda-developers: getevent behaves weird when piped, and busybox grep likes that even less than toolbox/toybox grep
	while (true); do
		/system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > "$TMPDIR"/events
		if (`cat "$TMPDIR"/events 2>/dev/null | /system/bin/grep VOLUME >/dev/null`); then
			break
		fi
	done
	if (`cat "$TMPDIR"/events 2>/dev/null | /system/bin/grep VOLUMEUP >/dev/null`); then
		return 1
	else
		return 0
	fi
}

# Check whether using a legacy device
if keytest; then
	FUNC=choose
else
	FUNC=false
	echo "!!! Error: Legacy device detected! skip setup."
	sleep_pause
	exit 1
fi

write() {
	echo "******************************************************"
	echo "--- $(date '+%Y-%m-%dT%H:%M:%S') ---"
	echo "------------------------------------------------------"
	echo "LD_LIBRARY_PATH=/vendor/lib64/hw KmInstallKeybox \"$TEE_Keybox_file\" \"$TEE_Device_ID\" true \"$RKP\""
	head -n2 "$TEE_Keybox_file"
	>&2 echo "No No NO No No."
	echo " "
}

# Main start
echo "******************************************************"
echo "!!! This module is NOT systemless. "
echo "!!! It performs permanent modifications to your "
echo "!!! device's partitions. These changes persist even "
echo "!!! after the module is uninstalled."
echo "******************************************************"
echo "!!! Please read the project's README "
echo "!!! and accept the risks before continuing."
echo "!!! https://github.com/muink/oneplus13-fix-tee-broken"
echo "******************************************************"
echo " "

# Ask user to accept the risks
echo "******************************************************"
echo "--- I acknowledge and accept these risks ---"
echo "  Vol+ = Yes"
echo "  Vol- = No"
echo "------------------------------------------------------"
if "$FUNC"; then
    echo "  Selected: No"
	sleep_pause
	exit 1
else
    echo "  Selected: Yes"
fi
echo " "

# Ask user to disable tricky store and play integrity fix
if [ -d "/data/adb/modules/tricky_store" -a ! -f "/data/adb/modules/tricky_store/disable" ] || [ -d "/data/adb/modules/playintegrityfix" -a ! -f "/data/adb/modules/playintegrityfix/disable" ]; then
    echo "!!! Error: Enabled 'Tricky Store' or "
    echo "!!! 'Play Integrity Fix' has been detected. "
	echo "!!! Please disable them and restart, "
	echo "!!! then run this module again."
	sleep_pause
	exit 1
fi

# Ask user to backup persist partition
echo "******************************************************"
echo "--- The persist partition has been backuped ---"
echo "  Vol+ = No"
echo "  Vol- = Yes"
echo "------------------------------------------------------"
if "$FUNC"; then
    echo "  Selected: Yes"
else
    echo "  Selected: No"
	sleep_pause
	exit 1
fi
echo " "

if [ -f "$TEE_Keybox_file" ]; then
# Ask user to install Custom Keybox
echo "******************************************************"
echo "--- Install Custom Keybox ---"
echo "  Vol+ = Yes"
echo "  Vol- = No"
echo "------------------------------------------------------"
if "$FUNC"; then
    echo "  Selected: No"
	RKP='rkp'
else
    echo "  Selected: Yes"
	RKP=''
fi
echo " "
fi

# Ask user to Final confirmation
echo "******************************************************"
echo "--- The write operation will now begin ---"
echo "--- Do you wish to continue ---"
echo "  Vol+ = Yes"
echo "  Vol- = No"
echo "------------------------------------------------------"
if "$FUNC"; then
    echo "  Selected: No"
	sleep_pause
	exit 1
else
    echo "  Selected: Yes"
fi
echo " "

# Ask user to Final confirmation
echo "******************************************************"
echo "--- The write operation will now begin ---"
echo "--- Do you wish to continue ---"
echo "  Vol+ = Yes"
echo "  Vol- = No"
echo "------------------------------------------------------"
if "$FUNC"; then
    echo "  Selected: No"
	sleep_pause
	exit 1
else
    echo "  Selected: Yes"
fi
echo " "

# Ask user to Final confirmation again
echo "******************************************************"
echo "--- This operation is irreversible ---"
echo "--- Do you wish to continue ---"
echo "  Vol+ = No"
echo "  Vol- = Yes"
echo "------------------------------------------------------"
if "$FUNC"; then
    echo "  Selected: Yes"
else
    echo "  Selected: No"
	sleep_pause
	exit 1
fi
echo " "

write 2>&1 | tee "$Log_file"

echo "******************************************************"
echo "> Done!"
sleep_pause
