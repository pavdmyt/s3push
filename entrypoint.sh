#!/bin/sh

[[ -z ${LOCAL_DIR} ]] || [[ -z ${S3_BUCKET_PATH} ]] && echo "Both LOCAL_DIR and S3_BUCKET_PATH must be set!" && exit 1
[[ ! -d ${LOCAL_DIR} ]] && echo "LOCAL_DIR must point to an existing directory" && exit 1

fileEvent=${1}
case "${fileEvent}" in
        y|n|m|d|c|D|M)
            echo "Local files have changed, syncing..."
            aws s3 sync ${LOCAL_DIR} ${S3_BUCKET_PATH}
            ;;
        '')
            echo "Performing initial sync at startup..."
            aws s3 sync ${LOCAL_DIR} ${S3_BUCKET_PATH}
            exec /sbin/inotifyd /bin/entrypoint.sh ${LOCAL_DIR}:cDMymnd 
            ;;
esac
