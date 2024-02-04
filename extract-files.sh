#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=NB1
VENDOR=nokia

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
        ## NB1 Patches
        # Patch gx_fpd for VNDK support
        vendor/bin/gx_fpd)
            "${PATCHELF}" --remove-needed "libunwind.so" "${2}" 
            "${PATCHELF}" --remove-needed "libbacktrace.so" "${2}"
            "${PATCHELF}" --add-needed "liblog.so" "${2}"
            "${PATCHELF}" --add-needed "libshim_binder.so" "${2}"
            ;;
        # Hexedit gxfingerprint to load goodix firmware from /vendor/firmware/
        vendor/lib64/hw/gxfingerprint.default.so)
            sed -i -e 's|/system/etc/firmware|/vendor/firmware\x0\x0\x0\x0|g' "${2}"
            ;;
        system_ext/etc/permissions/qti_fingerprint_interface.xml)
            sed -i -e 's|/system/framework|/system/system_ext/framework|g' "${2}"
            ;;
        # Use vendor version of libgui
        vendor/lib/hw/camera.msm8998.so)
            "${PATCHELF}" --replace-needed "libgui.so" "libgui_vendor.so" "${2}"
            "${PATCHELF}" --add-needed "libshim_gui.so" "${2}"
            ;;
        # Shim libdpmframework
        product/lib64/libdpmframework.so)
            "${PATCHELF}" --add-needed "libshim_cutils.so" "${2}"
            ;;
        # Health
        vendor/bin/hw/android.hardware.health@2.0-service)
            "${PATCHELF}" --replace-needed "libutils.so" "libutils-v30.so" "${2}"
            ;;
    esac
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"