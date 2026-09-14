FROM cgr.dev/chainguard/wolfi-base@sha256:9a8d954d8f03a21bcf2be73d4628f0ad26d35c3275469925de63a34eebd58f13

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
