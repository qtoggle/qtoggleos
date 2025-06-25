#!/bin/bash

# qtoggleserver.conf: add core.device_name.get_cmd
sed -ri 's,(set_cmd = "/usr/libexec/qs-device-name set"),get_cmd = "/usr/libexec/qs-device-name get"\n        \1,' /data/etc/qtoggleserver.conf
sed -ri 's/history_janitor_interval = .*/history_janitor_interval = 3600/' /data/etc/qtoggleserver.conf
