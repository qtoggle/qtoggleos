#!/bin/bash

# Reinstall qtoggleserver addon packages, if needed
if [[ -f /var/lib/upgrade/qtoggleserver-addons.txt ]]; then
    pip install -r /var/lib/upgrade/qtoggleserver-addons.txt
    rm /var/lib/upgrade/qtoggleserver-addons.txt
fi

# Upgrade all qtoggleserver-* packages
qts_packages=$(pip freeze | grep qtoggleserver- | cut -d '=' -f 1)

if [[ -n "${qts_packages}" ]]; then
    pip install --upgrade $qts_packages
fi
