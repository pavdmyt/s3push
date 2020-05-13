### Description

`s3push` is a dead simple script wrapped in a docker container. Upon start the script copies
files in the ${LOCAL_DIR} to remote ${S3_BUCKET_PATH}, then watches changes
to files in ${LOCAL_DIR}, and upon any changes copies the changed files to ${S3_BUCKET_PATH}.

### Configuration

Configuration is done via environment variables:

* **AWS_ACCESS_KEY_ID** and **AWS_SECRET_ACCESS_KEY**  
Valid AWS credentials.

* **LOCAL_DIR**  
Path to the local directory that will be watched for
changes.

* **S3_BUCKET_PATH**  
Path to the prefix inside an s3 bucket.
