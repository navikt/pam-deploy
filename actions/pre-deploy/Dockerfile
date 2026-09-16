FROM cgr.dev/chainguard/wolfi-base@sha256:3754b6da0e1ccdab0fe46abfdd7bbbba994b593c28149f6659fa6597f2261aeb

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
