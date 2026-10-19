FROM cgr.dev/chainguard/wolfi-base@sha256:c2a4815b6ca49b9bbafd451b4bde690d567a86b2b6b54877faac8082a7bc4296

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
