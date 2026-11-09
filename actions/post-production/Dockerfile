FROM cgr.dev/chainguard/wolfi-base@sha256:24f549a7fcace88e69b9557941168c74645688ecc4acf7fb6d734a6b74e9019d

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
