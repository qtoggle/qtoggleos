#!/bin/bash

# Remove old Python overlay dirs
python_version=$(python -V | cut -d ' ' -f 2 | cut -d . -f 1,2)
dirs=$(ls -1d /data/usr/lib/python?.* | grep -vE "python${python_version}/?$")
for dir in ${dirs}; do
    echo "Removing old Python data dir ${dir}"
    rm -rf "${dir}"
done
