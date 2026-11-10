# Redmi 15C 4G (dew) - starter tree, generated from device dumps. See README.md.
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

PRODUCT_DEVICE := dew
PRODUCT_NAME := twrp_dew
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := Redmi 15C
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_USE_DYNAMIC_PARTITIONS := true
