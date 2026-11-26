FROM cgr.dev/chainguard/wolfi-base@sha256:c902a861151182e4ce2de29b8632ba3f7d75b68c35880580f16e353819e524d3

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
