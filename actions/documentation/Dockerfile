FROM cgr.dev/chainguard/go:latest-dev@sha256:f383d8cd646b2fd893e6f698bfb243bf860f78811d7455596d88a6af7cafc424 AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /naisparser


FROM cgr.dev/chainguard/wolfi-base@sha256:7135c6a5e9f29b2542aaefee63d474973312bfdea95555963aef0e648210e4d2

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /naisparser /go/naisparser

ENTRYPOINT ["/entrypoint.sh"]
