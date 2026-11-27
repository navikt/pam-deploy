FROM cgr.dev/chainguard/wolfi-base@sha256:4cf5932a0f95a88af352f77e4efa67480cab0e1f7a48f0eddca3cce003a7c0fb

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
