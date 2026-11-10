DEVICE_PATH := device/xiaomi/dew

# Architecture (MT6768; userspace is 64-bit with 32-bit support, see bootopt=64S3,32N2,64N2)
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic

TARGET_BOARD_PLATFORM := mt6768
TARGET_BOOTLOADER_BOARD_NAME := dew
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

# A/B + dynamic partitions (super exists, slot _a active)
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += boot vendor_boot init_boot dtbo vbmeta vbmeta_system vbmeta_vendor
BOARD_SUPER_PARTITION_SIZE := 9663676416
# Group name/size are a guess (super minus 4 MiB, virtual A/B style); only matters for the build system.
BOARD_SUPER_PARTITION_GROUPS := xiaomi_dynamic_partitions
BOARD_XIAOMI_DYNAMIC_PARTITIONS_SIZE := 9659482112
BOARD_XIAOMI_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_ext vendor product mi_ext vendor_dlkm odm_dlkm system_dlkm

# Boot layout, from your dumps: boot_a v4 header with gzip Image and no ramdisk;
# vendor_boot_a v4 with a "platform" fragment (modules) and a "recovery" fragment.
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_PAGESIZE := 4096
BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_RAMDISK_USE_LZ4 := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE := 8388608
BOARD_DTBOIMG_PARTITION_SIZE := 8388608
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel

# Kernel is Linux 6.6.118-android15-8 (GKI); modules stay in the stock vendor_boot platform fragment.
# The repack script (tools/) reuses that fragment, so no modules are bundled here.

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery.fstab
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_HAS_LARGE_FILESYSTEM := true
TARGET_USES_MKE2FS := true
RECOVERY_SDCARD_ON_DATA := true
# Screen 720x1600 @ 320 dpi
TARGET_SCREEN_WIDTH := 720
TARGET_SCREEN_HEIGHT := 1600
TW_THEME := portrait_hdpi
TW_USE_TOOLBOX := true
TW_BRIGHTNESS_PATH := /sys/class/leds/lcd-backlight/brightness
TW_MAX_BRIGHTNESS := 4095
TW_DEFAULT_BRIGHTNESS := 2048

# Decryption: FBE aes-256-xts + metadata encryption (from fstab.mt6768).
# Needs the vendor keymint/Trustonic pieces to actually unlock /data; expect this to need work.
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
BOARD_USES_METADATA_PARTITION := true

PLATFORM_VERSION := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
