FROM cgr.dev/chainguard/go:latest-dev@sha256:21b175db480c45f8edd504d1a9bf80cc15f6026b2f427b0c03822c00a9dbb95b AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /naisparser


FROM cgr.dev/chainguard/wolfi-base@sha256:bef0f4d47edc72a93d1537eae54eb53db2b2cc352c028128ff0f16c5b5a3c1e4

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /naisparser /go/naisparser

ENTRYPOINT ["/entrypoint.sh"]
