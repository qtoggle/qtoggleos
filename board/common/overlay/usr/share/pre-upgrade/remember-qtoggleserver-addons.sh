#!/bin/bash

# Remember currently installed qtoggleserver addon packages, as we might need to reinstall them after upgrade
mkdir -p /var/lib/upgrade
pip list | grep qtoggleserver- | grep -v rpigpio | cut -d ' ' -f 1 > /var/lib/upgrade/qtoggleserver-addons.txt
