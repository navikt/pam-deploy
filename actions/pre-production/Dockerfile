FROM cgr.dev/chainguard/wolfi-base@sha256:bc76fa39ddd1482dd56a761b3331e03ba8f0e093ebb525618a56d014b480da88

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
