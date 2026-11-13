FROM cgr.dev/chainguard/wolfi-base@sha256:ae9575b121f5776e2f04e192064bc2c5665af9d1c425d620dc773aca31698712

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
