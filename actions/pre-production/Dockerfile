FROM cgr.dev/chainguard/wolfi-base@sha256:150a90c21d962ea400988490b629e245658391b63a1f625e847f5dea50dd3094

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
