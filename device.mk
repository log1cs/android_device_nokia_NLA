#
# Copyright (C) 2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/nokia/NLA

# Keylayout
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/keylayout/goodix_fp.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/goodix_fp.kl

# Shims
PRODUCT_PACKAGES += \
    libshim_binder

# Soong
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH)

# Recovery
PRODUCT_PACKAGES += \
    librecovery_updater_nokia

# Inherit device specific vendor makefiles
$(call inherit-product, vendor/nokia/NLA/NLA-vendor.mk)
