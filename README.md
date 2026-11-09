# OrangeFox starter tree: Redmi 15C 4G (dew), HyperOS 3 / Android 16, MT6768, A/B

Built from dumps of OS3.0.307.0.WBNMIXM. **Untested**: nobody has booted this yet.
Recovery lives in `vendor_boot` (v4 header, "recovery" ramdisk fragment); the kernel is stock `boot`.
Plan: build OrangeFox's recovery ramdisk in GitHub Actions, then swap ONLY the recovery fragment
into your own stock `vendor_boot_a` (keeps its 164 kernel modules, dtb and header) with `tools/repack_vendor_boot.py`.

## 1. TODOs
Screen size, super size and backlight values are filled in from your phone. Nothing left to fill.

## 2. Build
Create a GitHub repo with this folder as its root, open Actions -> "Build OrangeFox (dew)" -> Run workflow.
Download the `orangefox-dew` artifact (vendor_boot.img and/or ramdisk-recovery.*). If it fails, send the log tail.

## 3. Repack (Termux: `pkg install python`)
    python3 tools/repack_vendor_boot.py vendor_boot_a.img <built vendor_boot.img or ramdisk-recovery.img> vendor_boot_new.img
`vendor_boot_a.img` must be the stock one from the fastboot ROM zip for your build.

## 4. Flash (slot A only)
    fastboot --disable-verity --disable-verification flash vbmeta_a vbmeta_a.img   # stock vbmeta_a from the ROM zip
    fastboot flash vendor_boot_a vendor_boot_new.img
    fastboot reboot recovery
The repacked image has no AVB footer, so vbmeta verification must be off for it to boot.

## Restore
    fastboot flash vendor_boot_a vendor_boot_a.img   # stock, from the ROM zip
    fastboot flash vbmeta_a vbmeta_a.img

## Known weak spots
/data decryption (FBE aes-256-xts + metadata encryption, Trustonic TEE) will likely not unlock at first;
touch may not work (no touch module is in the stock recovery module list); the OrangeFox flags in
vendorsetup.sh and the fstab flag syntax are from memory and may need adjusting after the first build log.
