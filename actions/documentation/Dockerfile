FROM cgr.dev/chainguard/go:latest-dev@sha256:ffa820c813d3a6c88458f51619ef8a4f26bb3e4a16d71acdd2472eed7a051b4e AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /naisparser


FROM cgr.dev/chainguard/wolfi-base@sha256:05d24163df148be377275af8374c16523a1dc7e19bf4f1c689784791553c5e45

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /naisparser /go/naisparser

ENTRYPOINT ["/entrypoint.sh"]
