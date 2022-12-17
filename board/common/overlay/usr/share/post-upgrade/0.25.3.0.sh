#!/bin/bash

# qtoggleserver.conf: add system.setup_mode_cmd
setup_mode_cmd='    setup_mode_cmd = "/usr/libexec/qs-setup-mode"'

sed -ri "s,(system = \{),\1\n${setup_mode_cmd},g" /data/etc/qtoggleserver.conf
