#!/bin/bash

# qtoggleserver.conf: fwupdate_driver -> fwupdate.driver
sed -i 's/fwupdate_driver = "thingos.ThingOSDriver"/fwupdate = {\n        driver = "thingos.ThingOSDriver"\n    }/' /data/etc/qtoggleserver.conf

# qtoggleserver.conf: remove date updating support
cat /data/etc/qtoggleserver.conf | tr '\n' '\t' | sed -r 's/date = \{[^\}]+\}\s+//' | tr '\t' '\n' > /data/etc/qtoggleserver.conf.bak
mv /data/etc/qtoggleserver.conf.bak /data/etc/qtoggleserver.conf
