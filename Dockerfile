# There is no aws-cli package yet in latest stable alpine, so
# for now we are using edge. Don't forget to change this
# when aws-cli lands in the stable repo.
FROM alpine:edge

RUN apk add --no-cache aws-cli
COPY entrypoint.sh /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]

