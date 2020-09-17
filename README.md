### Description

`s3push` is a dead simple script wrapped in a docker container. Upon start the script copies
files in the **LOCAL_DIRS** to remote **S3_BUCKET**. After that it watches changes
to files in **LOCAL_DIRS**, and upon any change copies the changed files to **S3_BUCKET**.

The script uses `inotifyd` to watch for changes. Keep in mind that `inotifyd` does not react to changes
that happens to files in subdirectories of the watched directory. In other words, with the following
directory structure
```
/certs/
├── accounts/
│   ├── 1.json
│   └── stuff/
│       └── text.md
└── certificates/
    ├── sample.key
    └── sample.crt
```
And the following settings:
```
LOCAL_DIRS="/certs/certificates /certs/accounts"
S3_BUCKET="s3://some-bucket"
```

Upon any changes to files in `/certs/accounts` or `/certs/certificates` these directories
will be synchronized with `s3://some-bucket/accounts` and `s3://some-bucket/certificates`.
However, changes to files in `/certs/accounts/stuff` won't trigger the sync process.

### Configuration

Configuration is done via environment variables:

* **AWS_ACCESS_KEY_ID** and **AWS_SECRET_ACCESS_KEY**  
Valid AWS credentials.

* **LOCAL_DIRS**  
Path to the local directories that will be watched for
changes.

* **S3_BUCKET**  
Path to the prefix inside an s3 bucket.

### Caveats

If you get "no space left on the device" error when running the script, most probably
it means that `fs.inotify.max_user_watches` sysctl arg is set too low. 
Quick fix:
```
echo fs.inotify.max_user_watches=1048576 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```