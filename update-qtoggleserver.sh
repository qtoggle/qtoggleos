#!/bin/sh

if [ -z "$1" ]; then
    echo "missing argument version"
    return 1
fi

cd $(dirname $0)
sed -ri "s/QTOGGLESERVER_VERSION = .*/QTOGGLESERVER_VERSION = $1/" package/qtoggleserver/qtoggleserver.mk
git commit -am "qtoggleserver: Update to $1"
