### Description

`s3push` is a dead simple script wrapped in a docker container. Upon start the script copies
files in the **LOCAL_DIR** to remote **S3_BUCKET_PATH**. After that it watches changes
to files in **LOCAL_DIR**, and upon any change copies the changed files to **S3_BUCKET_PATH**.

The script uses `inotifyd` to watch for changes. Unfortunately, `inotifyd` can't watch for
changes in subdirectories of the **LOCAL_DIR**, but it can watch for changes in multiple
directories. If you want to watch multiple directories, set **WATCH_DIRS** env variable. For example, given the following directory structure:
```
base/
├── one
│   ├── 1.txt
│   └── 2.txt
├── other
│   └── 4.txt
└── two
    └── 3.txt
```
And the following settings:
```
LOCAL_DIR=base
WATCH_DIRS="base/one base/two"
S3_BUCKET_PATH="s3://some-bucket"
```
you will have local `base` dir and all its subdirectories synced to `s3://some-bucket/` upon every change to files under `base/one` and `base/two` local dirs.

### Configuration

Configuration is done via environment variables:

* **AWS_ACCESS_KEY_ID** and **AWS_SECRET_ACCESS_KEY**  
Valid AWS credentials.

* **LOCAL_DIR**  
Path to the local directory that will be watched for
changes.

* **WATCH_DIRS**
If you need to watch multiple directories for changes, 
list them here, e.g.: `WATCH_DIRS="/some/path/dir1 /some/path/dir2 /some/path/dir3"`.

* **S3_BUCKET_PATH**  
Path to the prefix inside an s3 bucket.

### Caveats

If you get "no space left on the device" error when running the script, most probably
it means that `fs.inotify.max_user_watches` sysctl arg is set too low. 
Quick fix:
```
echo fs.inotify.max_user_watches=1048576 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```