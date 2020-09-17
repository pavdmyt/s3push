#!/bin/bash

[[ -z ${LOCAL_DIRS} ]] || [[ -z ${S3_BUCKET} ]] && echo "Both LOCAL_DIRS and S3_BUCKET must be set!" && exit 1

for d in ${LOCAL_DIRS}; do
        [[ ! -d ${d} ]] && mkdir -p ${d}
        aws s3 sync ${S3_BUCKET}/${d##*/} ${d}
done
