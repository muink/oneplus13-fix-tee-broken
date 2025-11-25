# OnePlus 13 TEE Repair Module

`oneplus13-fix-tee-broken` is a specialized utility designed to restore the functionality of the Trusted Execution Environment (TEE) on OnePlus 13, 13T, and 13S devices. This module addresses specific TEE attestation failures and Widevine RKP issues.

⚠️ Critical Warning and Disclaimer

PLEASE READ CAREFULLY BEFORE PROCEEDING.

> [!WARNING]\
> Non-Systemless Operation: This module is NOT systemless. It performs permanent modifications to your device's partitions. These changes persist even after the module is uninstalled.
> Risk of Damage: The operations performed by this module carry inherent risks. Improper use or unexpected errors may damage the device or cause it to malfunction.
> Liability: By using this module, you acknowledge and accept these risks. The author(s) and contributors of this project assume no liability for any damage to your device, loss of data, or voiding of warranties resulting from the use of this software.

## 1. Prerequisites

- Supported Devices: OnePlus 13, OnePlus 13T, OnePlus 13S.
- Root Environment: A functioning root solution installed (Magisk, KernelSU, or APatch).
- ADB Access: A computer with ADB tools installed for partition backup.

[Download](https://github.com/muink/oneplus13-fix-tee-broken/releases)

## 2. Installation and Usage Guide

1. Install the module zip file via your preferred root manager.
2. Reboot your device immediately after installation.
3. Backup `persist` partition
   - Before executing the repair script, you should back up the persist partition. This is critical for recovery if the operation fails.
   - Execute the following command via ADB (root privileges must be granted to `adb shell` beforehand):
``` shell
adb shell su -c dd if=/dev/block/bootdevice/by-name/persist of=/sdcard/Download/persist-$(date "+%Y%m%dT%H%M%S").img
```
4. Ensure the backup file is successfully created in your device's Download folder before proceeding.
5. Open your root manager (Magisk/KernelSU/APatch).
6. Navigate to the Modules section.
7. Locate `oneplus13-fix-tee-broken`.
8. Tap the `Action` button (often labeled as "Action" or shown as a Play icon).
9. Follow the on-screen terminal prompts to complete the repair process.

## 3. Custom Keybox Injection

Advanced users may inject a custom Keybox into the TEE.

1. Prepare the Keybox: Ensure you possess a valid keybox.xml.
   - Note: Do not use a Keybox that has been revoked or is at high risk of revocation by Google.
2. Placement: Copy your keybox file to the following directory on the device:
   - `/data/adb/modules/oneplus13-fix-tee-broken/keybox.xml`
2. Re-execution: Re-run the module execution (refer to step 3.8).

> [!NOTE]\
> If the write operation fails during re-execution, it may be necessary to restore the `persist` partition
> from your backup before retrying. (Untested, insufficient sample size, probability questionable)

## 4. References and Acknowledgements

This project references research and methods documented in the following source:

[一加13/15使用KmInstallKeybox修复attestation key+widevine RKP+attestation RKP测试](https://wuxianlin.com/2025/11/12/oneplus-13-15-attestation-rkp-test/)
