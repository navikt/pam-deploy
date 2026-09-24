FROM cgr.dev/chainguard/wolfi-base@sha256:b6bfe8564bb0630778b04df06b42e78acf221e9540703cfc03d040ab7f91e357

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
