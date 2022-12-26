#!/bin/bash

# Starting with version 0.26, the following Python deps are installed as built-in,
# so we have to remove any user-installed versions.

rm -rf /data/usr/lib/python3.9/site-packages/argparse*
rm -rf /data/usr/lib/python3.9/site-packages/bleak*
rm -rf /data/usr/lib/python3.9/site-packages/charset*
rm -rf /data/usr/lib/python3.9/site-packages/construct*
rm -rf /data/usr/lib/python3.9/site-packages/dbus*
rm -rf /data/usr/lib/python3.9/site-packages/paradox*
rm -rf /data/usr/lib/python3.9/site-packages/pymodbus*
rm -rf /data/usr/lib/python3.9/site-packages/pyserial*
rm -rf /data/usr/lib/python3.9/site-packages/python_slugify*
rm -rf /data/usr/lib/python3.9/site-packages/qtoggleserver*
rm -rf /data/usr/lib/python3.9/site-packages/requests*
rm -rf /data/usr/lib/python3.9/site-packages/serial*
rm -rf /data/usr/lib/python3.9/site-packages/slugify*
rm -rf /data/usr/lib/python3.9/site-packages/text_unidecode*
rm -rf /data/usr/lib/python3.9/site-packages/urllib3*

mount -o remount /usr
