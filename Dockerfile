FROM alpine:3.12

RUN apk add --no-cache aws-cli
COPY entrypoint.sh /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]

