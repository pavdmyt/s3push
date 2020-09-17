#!/bin/bash

[[ -z ${LOCAL_DIRS} ]] || [[ -z ${S3_BUCKET} ]] && echo "Both LOCAL_DIRS and S3_BUCKET must be set!" && exit 1

for d in ${LOCAL_DIRS}; do
        [[ ! -d ${d} ]] && mkdir -p ${d}
done

fileEvent=${1}
case "${fileEvent}" in
        y|n|m|d|c|D|M)
            echo "Local files have changed, syncing..."
            for d in ${LOCAL_DIRS}; do
                aws s3 sync ${d} ${S3_BUCKET}/${d##*/}
            done
            ;;
        '')
            echo "Performing initial sync at startup..."
            for d in ${LOCAL_DIRS}; do
                aws s3 sync ${d} ${S3_BUCKET}/${d##*/}
            done
            exec /sbin/inotifyd /bin/entrypoint.sh $(sed -r 's/( +|$)/:cDMymnd /g' <<< "${LOCAL_DIRS}")
            ;;
esac
