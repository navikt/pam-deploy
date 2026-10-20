FROM cgr.dev/chainguard/wolfi-base@sha256:d68b2b10db0ddb2c6d9cb3a7720ecab5ca19b4b430fd592cd07c23d7da971b56

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
