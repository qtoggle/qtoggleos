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
        if [[ "${path}" == *:* ]]; then
            IFS=: path=(${path}); unset IFS
            src=${path[0]}
            dst=${path[1]}
        else
            src=${path}
            dst=${path}
        fi
        
        test -e "${TARGET}${src}" || continue
        rm -rf "${ext_dir}/root${dst}"

        cp -a "${TARGET}${src}" "${ext_dir}/root${dst}"
        rm -rf "${TARGET}${src}"
    done
done
