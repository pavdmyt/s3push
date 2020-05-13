FROM alpine:edge

RUN apk add --no-cache aws-cli
COPY entrypoint.sh /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]

