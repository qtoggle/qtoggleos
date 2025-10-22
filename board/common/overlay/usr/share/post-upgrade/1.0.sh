#!/bin/bash

# qtoggleserver.conf: replace `/usr/libexec/qs-*` with `/host/usr/libexec/qtoggleserver/qs-*`
sed -ri 's,/usr/libexec/qs-(\w+),/host/usr/libexec/qtoggleserver/qs-\1,g' /data/etc/qtoggleserver.conf

# qtoggleserver.conf: replace `ssl_support` with `tls_support`
sed -ri 's/ssl_support/tls_support/g' /data/etc/qtoggleserver.conf

# qtoggleserver.conf: replace `PostgreSQLDriver` with `PostgresDriver`
sed -ri 's/PostgreSQLDriver/PostgresDriver/g' /data/etc/qtoggleserver.conf

# qtoggleserver.conf: replace `thingos.ThingOSDriver` with `qtoggleos.fwupdate.FWUpdateDriver`
sed -ri 's/thingos.ThingOSDriver/qtoggleos.fwupdate.FWUpdateDriver/g' /data/etc/qtoggleserver.conf

# Move `/data/etc/qtoggleserver.conf` to `/data/qtoggleserver/etc/qtoggleserver.conf`
mkdir -p /data/qtoggleserver/etc/
mv /data/etc/qtoggleserver.conf /data/qtoggleserver/etc/qtoggleserver.conf

# Remember addons from previous environment
cat /data/usr/lib/python3.9/site-packages/qtoggleserver_*/PKG-INFO | grep -E ^Name: | cut -d ' ' -f 2 > /data/qtoggleserver/requirements.txt

# Remove old /usr overlay folders
rm -rf /data/.overlay-usr
rm -rf /data/usr
