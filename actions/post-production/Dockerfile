FROM cgr.dev/chainguard/wolfi-base@sha256:103eb3f4444c68ea2453bf3aad09d860eaa5a698effb3e656cd607f630f0e46d

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
