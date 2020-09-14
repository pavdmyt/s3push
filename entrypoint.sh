#!/bin/bash

[[ -z ${LOCAL_DIR} ]] || [[ -z ${S3_BUCKET_PATH} ]] && echo "Both LOCAL_DIR and S3_BUCKET_PATH must be set!" && exit 1
[[ ! -d ${LOCAL_DIR} ]] && echo "LOCAL_DIR must point to an existing directory" && exit 1

if [[ -v ${WATCH_DIRS} ]]; then
    for d in ${WATCH_DIRS}; do
        mkdir -p ${d}
    done
else
    export WATCH_DIRS=${LOCAL_DIR}
fi

watch_args=""
for d in ${WATCH_DIRS}; do
    watch_args="${watch_args}${d}:cDMymnd "
done

fileEvent=${1}
case "${fileEvent}" in
        y|n|m|d|c|D|M)
            echo "Local files have changed, syncing..."
            aws s3 sync ${LOCAL_DIR} ${S3_BUCKET_PATH}
            ;;
        '')
            echo "Performing initial sync at startup..."
            aws s3 sync ${LOCAL_DIR} ${S3_BUCKET_PATH}
            exec /sbin/inotifyd /bin/entrypoint.sh "${watch_args}"
            ;;
esac
