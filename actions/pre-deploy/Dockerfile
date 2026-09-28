FROM cgr.dev/chainguard/wolfi-base@sha256:08df5982c3d27e70a4ce1607e3bb9af09d746f8722cf135a7694afef879fc5a2

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
