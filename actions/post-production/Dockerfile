FROM cgr.dev/chainguard/wolfi-base@sha256:7135c6a5e9f29b2542aaefee63d474973312bfdea95555963aef0e648210e4d2

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
