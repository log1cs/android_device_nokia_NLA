#
# Copyright (C) 2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/nokia/NLA

# Shims
PRODUCT_PACKAGES += \
    libshim_binder

# Inherit device specific vendor makefiles
$(call inherit-product, vendor/nokia/NLA/NLA-vendor.mk)
