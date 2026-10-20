FROM cgr.dev/chainguard/go:latest-dev@sha256:a63df402ab191ea6551c8a25c767b1774ab1854285d50d0ace6dac1f69435d27 AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /naisparser


FROM cgr.dev/chainguard/wolfi-base@sha256:d68b2b10db0ddb2c6d9cb3a7720ecab5ca19b4b430fd592cd07c23d7da971b56

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /naisparser /go/naisparser

ENTRYPOINT ["/entrypoint.sh"]
