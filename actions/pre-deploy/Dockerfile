FROM cgr.dev/chainguard/wolfi-base@sha256:d13acb327aa77acf2752acea8c08456511a5b8142455cc2fe0f966b960bf64c6

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
