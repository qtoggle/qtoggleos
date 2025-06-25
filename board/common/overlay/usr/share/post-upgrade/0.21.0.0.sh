#!/bin/bash

# qtoggleserver.conf: add slaves.discover
discover_section='    discover = { \
        dhcp_timeout = 10 \
        ap = { \
            interface_cmd = "/usr/libexec/qs-ap-interface" \
            finish_timeout = 300 \
        } \
    }'

sed -ri "s,(\s+retry_count = .*),\1\n${discover_section},g" /data/etc/qtoggleserver.conf
