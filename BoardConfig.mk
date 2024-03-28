#
# Copyright (C) 2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/nokia/NLA

# Inherit from common device tree
include device/nokia/msm8998-common/BoardConfigCommon.mk

# Kernel
TARGET_KERNEL_CONFIG := lineageos_NLA_defconfig

# SEPolicy
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

# Props
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# Include the proprietary files
include vendor/nokia/NLA/BoardConfigVendor.mk
