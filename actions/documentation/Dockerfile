FROM cgr.dev/chainguard/go:latest-dev@sha256:e7caea41274bfa0ee609e5cc77a40e3c9ab500fd55eb16a3fadbe2c3472927a4 AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /naisparser


FROM cgr.dev/chainguard/wolfi-base@sha256:00fd4e9cdd9c5576c336d979fa663f9976f160c456b6ae9fe87e19c4e9c759a2

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /naisparser /go/naisparser

ENTRYPOINT ["/entrypoint.sh"]
