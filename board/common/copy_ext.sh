#!/bin/bash

OUTPUT_DIR=$(dirname ${TARGET})

for file in ${COMMON_DIR}/ext-*.conf; do
    ext=$(basename ${file})
    ext=${ext:4:-5}
    echo "Copying contents for extension ${ext}"
    ext_dir=${OUTPUT_DIR}/extensions/${ext}
    mkdir -p ${ext_dir}/root
    source ${file}
    for path in ${PATHS}; do
        test -e "${TARGET}${path}" || continue
        dir=$(dirname ${path})
        mkdir -p ${ext_dir}/root/${dir}
        cp -a "${TARGET}${path}" "${ext_dir}/root/${dir}" && rm -rf "${TARGET}${path}"
    done
done
