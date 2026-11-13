FROM cgr.dev/chainguard/go:latest-dev@sha256:ff52aa1440908b2b6a4c287013d7d5010806f16eb2de0a817934490a7ea7601d AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /naisparser


FROM cgr.dev/chainguard/wolfi-base@sha256:ae9575b121f5776e2f04e192064bc2c5665af9d1c425d620dc773aca31698712

RUN apk add --no-cache bash curl jq sed git tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /naisparser /go/naisparser

ENTRYPOINT ["/entrypoint.sh"]
