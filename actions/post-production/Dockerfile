FROM cgr.dev/chainguard/wolfi-base@sha256:05d24163df148be377275af8374c16523a1dc7e19bf4f1c689784791553c5e45

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
