FROM cgr.dev/chainguard/wolfi-base@sha256:65e1acb87a2bf356b92c5f70f3980f03b4bb51dfd483c834e01557525f15c1d9

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
