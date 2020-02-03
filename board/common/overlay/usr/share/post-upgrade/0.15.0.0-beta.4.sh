#!/bin/bash

# qtoggleserver.conf: move device_name -> core.device_name
sed -i '/^device_name.*/,+3d' /data/etc/qtoggleserver.conf
sed -ri 's/(    tick_interval)/    device_name = {\n        set_cmd = "\/usr\/libexec\/qs-device-name set"\n    }\n\1/' /data/etc/qtoggleserver.conf

# qtoggleserver.conf: move password_set_cmd -> core.passwords.set_cmd
sed -i '/^password_set_cmd.*/,+1d' /data/etc/qtoggleserver.conf
sed -ri 's/(    tick_interval)/    passwords = {\n        set_cmd = "\/usr\/libexec\/qs-password set"\n    }\n\n\1/' /data/etc/qtoggleserver.conf
