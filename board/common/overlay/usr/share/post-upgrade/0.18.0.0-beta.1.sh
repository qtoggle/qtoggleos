#!/bin/bash

# qtoggleserver.conf: add system.storage
sed -ri 's/(\s+)(fwupdate)/\1storage = {\n\1\1path = "\/data"\n\1}\n\1\2/g' /data/etc/qtoggleserver.conf

# qtoggleserver.conf: add system.temperature
sed -ri 's/(\s+)(fwupdate)/\1temperature = {\n\1\1get_cmd = "\/usr\/libexec\/qs-temperature get"\n\1}\n\1\2/g' /data/etc/qtoggleserver.conf
