FROM cgr.dev/chainguard/wolfi-base@sha256:238642d42c5613936474d00b900c4e65fb6f637d8991c913403ff09a09cf43a3

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
