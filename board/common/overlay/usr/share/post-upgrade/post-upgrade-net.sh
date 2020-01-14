#!/bin/bash

# Upgrade all qtoggleserver-* packages
qts_packages=$(pip freeze | grep qtoggleserver- | cut -d '=' -f 1)

if [[ -n "${qts_packages}" ]]; then
    pip install --upgrade $qts_packages
fi
