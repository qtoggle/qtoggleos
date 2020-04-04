#!/bin/bash

# qtoggleserver.conf: fwupdate_driver -> fwupdate.driver
sed -i 's/fwupdate_driver = "thingos.ThingOSDriver"/fwupdate = {\n        driver = "thingos.ThingOSDriver"\n    }/' /data/etc/qtoggleserver.conf
