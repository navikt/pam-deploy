FROM cgr.dev/chainguard/go:latest-dev@sha256:636f4705d07bbacc1cc9c7abde2fd42caa3ec85103556a9743e2b2db0809bd3b AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /naisparser


FROM cgr.dev/chainguard/wolfi-base@sha256:4cf5932a0f95a88af352f77e4efa67480cab0e1f7a48f0eddca3cce003a7c0fb

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /naisparser /go/naisparser

ENTRYPOINT ["/entrypoint.sh"]
