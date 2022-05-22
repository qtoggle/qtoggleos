#!/bin/bash

TMP_ROOT_DIR=/tmp/fwupdate_root

if [[ -f ${TMP_ROOT_DIR}/usr/libexec/fw-restore-boot-cfg ]]; then
    cp ${TMP_ROOT_DIR}/usr/libexec/fw-restore-boot-cfg /usr/libexec/fw-restore-boot-cfg
else
    rm -f /usr/libexec/fw-restore-boot-cfg
fi
