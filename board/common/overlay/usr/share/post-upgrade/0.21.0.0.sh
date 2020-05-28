#!/bin/bash

# qtoggleserver.conf: add slaves.discover
discover_section='    discover = { \
        enabled = true \
        dhcp_timeout = 10 \
        ap = { \
            interface = "ap0" \
            target_ssid = null \
            target_psk = null \
            finish_timeout = 300 \
        } \
    }'

sed -ri "s/(\s+retry_count = .*)/\1\n${discover_section}/g" /data/etc/qtoggleserver.conf
