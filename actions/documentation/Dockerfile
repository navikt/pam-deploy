FROM bash:5.0

RUN apk add --no-cache curl jq sed git tzdata gh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]