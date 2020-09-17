FROM alpine:3.12

RUN apk add --no-cache aws-cli bash
COPY entrypoint.sh /bin/entrypoint.sh
COPY s3pull.bash /bin/s3pull.bash

ENTRYPOINT ["/bin/entrypoint.sh"]

