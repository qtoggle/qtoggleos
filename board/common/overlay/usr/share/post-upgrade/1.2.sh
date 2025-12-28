#!/bin/bash

# qtoggleserver.conf: add new serial_number attribute
new_content='    device_attrs = [
        {
           "driver": "qtoggleserver.drivers.device_attrs.CmdLineAttrDef"
           "name": "serial_number"
           "display_name": "Serial Number"
           "description": "The serial number of the device"
           "type": "string"
           "get_cmd": "/host/usr/libexec/qtoggleserver/qs-serial-number"
           "cache_lifetime": 3600
       }
    ]'
new_content=$(echo "${new_content}" | tr '\n' '|' | sed 's/|/\\n/g')
sed -ri 's,(virtual_ports = [[:digit:]]+),\1\n\n'"${new_content}"',' /data/qtoggleserver/etc/qtoggleserver.conf

# qtoggleserver.conf: add remote metadata entries

new_content='
metadata = [
    {
       "name": "qtoggleos.remote.handle"
       "cmd": "/host/usr/libexec/qtoggleserver/qs-remote handle"
    }
    {
       "name": "qtoggleos.remote.password"
       "cmd": "/host/usr/libexec/qtoggleserver/qs-remote password"
    }
]'

echo "${new_content}" >> /data/qtoggleserver/etc/qtoggleserver.conf

