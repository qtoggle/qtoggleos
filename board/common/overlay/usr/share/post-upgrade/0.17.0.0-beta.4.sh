#!/bin/bash

# qtoggleserver.conf: fwupdate_driver -> fwupdate.driver
sed -i 's/fwupdate_driver = "thingos.ThingOSDriver"/fwupdate = {\n        driver = "thingos.ThingOSDriver"\n    }/' /data/etc/qtoggleserver.conf

# qtoggleserver.conf: remove date updating support
awk '/date = /{c=4} c&&c--{next} 1' /data/etc/qtoggleserver.conf > /data/etc/qtoggleserver.conf.bak
mv /data/etc/qtoggleserver.conf.bak /data/etc/qtoggleserver.conf
